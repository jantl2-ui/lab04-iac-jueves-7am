import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';
import busboy from 'busboy';
import { v4 as uuidv4 } from 'uuid';

const s3 = new S3Client({});
const BUCKET = process.env.S3_BUCKET;
const PREFIX = process.env.UPLOAD_PREFIX || 'uploads/';

export const handler = async (event) => {
    return new Promise((resolve) => {
        const contentType = event.headers['content-type'] || event.headers['Content-Type'];

        if (!contentType || !contentType.includes('multipart/form-data')) {
            return resolve({ statusCode: 400, body: 'Formato inválido. Se requiere multipart/form-data.' });
        }

        const bb = busboy({ headers: { 'content-type': contentType } });
        let uploadPromises = [];

        bb.on('file', (name, file, info) => {
            const { filename, mimeType } = info;
            const extension = filename.split('.').pop();
            const uniqueFilename = `${uuidv4()}.${extension}`;
            const key = `${PREFIX}${uniqueFilename}`;

            let chunks = [];
            file.on('data', (data) => chunks.push(data));

            file.on('end', () => {
                const buffer = Buffer.concat(chunks);
                const upload = s3.send(new PutObjectCommand({
                    Bucket: BUCKET,
                    Key: key,
                    Body: buffer,
                    ContentType: mimeType
                }));
                uploadPromises.push(upload);
            });
        });

        bb.on('finish', async () => {
            try {
                await Promise.all(uploadPromises);
                resolve({
                    statusCode: 200,
                    body: JSON.stringify({ message: 'Imagen subida exitosamente' })
                });
            } catch (error) {
                console.error("Error subiendo a S3:", error);
                resolve({ statusCode: 500, body: 'Error interno del servidor' });
            }
        });

        // Manejar el body de API Gateway (Payload 2.0 con isBase64Encoded)
        const bodyBuffer = event.isBase64Encoded
            ? Buffer.from(event.body, 'base64')
            : Buffer.from(event.body || '', 'utf8');

        bb.end(bodyBuffer);
    });
};