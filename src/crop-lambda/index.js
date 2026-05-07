import { S3Client, GetObjectCommand, PutObjectCommand } from '@aws-sdk/client-s3';
import sharp from 'sharp';

const s3 = new S3Client({});
const BUCKET = process.env.S3_BUCKET;
const PROCESSED_PREFIX = process.env.PROCESSED_PREFIX || 'processed/';

// Buffer SVG para crear una máscara circular perfecta
const circleSvg = `<svg width="40" height="40"><circle cx="20" cy="20" r="20" /></svg>`;

export const handler = async (event) => {
    const batchItemFailures = [];

    for (const record of event.Records) {
        try {
            // El body de SQS contiene el evento de notificación de S3 en formato string
            const sqsBody = JSON.parse(record.body);

            // Validar que sea un evento de S3 (podría ser un evento de prueba)
            if (!sqsBody.Records || !sqsBody.Records[0].s3) continue;

            const s3Event = sqsBody.Records[0].s3;
            const originalKey = decodeURIComponent(s3Event.object.key.replace(/\+/g, " "));

            // 1. Obtener la imagen original de uploads/
            const getObjectResult = await s3.send(new GetObjectCommand({
                Bucket: BUCKET,
                Key: originalKey
            }));
            const imageBuffer = await getObjectResult.Body.transformToByteArray();

            // 2. Procesar con Sharp (40x40, cubrir, máscara circular SVG, PNG transparente)
            const processedBuffer = await sharp(imageBuffer)
                .resize(40, 40, { fit: 'cover' })
                .composite([{ input: Buffer.from(circleSvg), blend: 'dest-in' }])
                .png({ alpha: true })
                .toBuffer();

            // 3. Generar el nuevo Key (reemplazando carpeta y extensión)
            const filename = originalKey.split('/').pop().split('.')[0];
            const processedKey = `${PROCESSED_PREFIX}${filename}_circular.png`;

            // 4. Subir imagen procesada a S3
            await s3.send(new PutObjectCommand({
                Bucket: BUCKET,
                Key: processedKey,
                Body: processedBuffer,
                ContentType: 'image/png'
            }));

            console.log(`Imagen procesada exitosamente: ${processedKey}`);

        } catch (error) {
            console.error(`Error procesando el mensaje ${record.messageId}:`, error);
            // Agregamos el ID al array para que SQS reintente solo este mensaje (ReportBatchItemFailures)
            batchItemFailures.push({ itemIdentifier: record.messageId });
        }
    }

    return { batchItemFailures };
};