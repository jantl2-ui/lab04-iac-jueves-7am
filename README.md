Paso 1: Preparación del Código Fuente (Lambdas)
Antes de ejecutar cualquier comando de Terraform, es obligatorio instalar las dependencias de Node.js.

Para crop-lambda: Dado que utilizamos la librería sharp (que depende de binarios en C++), debemos realizar una compilación cruzada para que funcione correctamente en el entorno de AWS Lambda (Amazon Linux x64), ignorando el sistema operativo de tu máquina local.

Abre tu terminal en la raíz del proyecto y ejecuta:

Para upload-lambda:
npm install

Para crop-lambda:

npm install --cpu=x64 --os=linux libc=glibc sharp

Paso 2: Despliegue

```
Empezamos con el entorno "dev"

Primero ejecutamos lo siguiente para inicializar terraform:
```bash   
cd environments/dev
terraform init
```
Segundo creamos el workspace para el ambiente dev:
```bash   
terraform workspace new dev
```
Tercero listamos los workspaces para verificar que se creó el workspace de dev:
```bash   
terraform workspace list
```
Cuarto usamos el workspace de dev:
```bash   
terraform workspace select dev
```
Quinto validamos y vemos lo que se va a crear:
```bash   
terraform validate
```
```bash   
terraform plan
```

Sexto aplicamos el plan de terraform:
```bash   
terraform apply
```


si queremos pasar a otro entorno lo hacemos de la siguiente manera, pero tenemos primero crearlo, en caso no lo hayamos creado, como vismos antes (terraform workspace new qa): 

```bash   
terraform workspace select qa
```

Y hacemos lo mismo que hicimos con el anterior entorno, solo que esta vez con el entorno qa:

```bash
terraform workspace select qa
terraform validate
terraform plan
terraform apply
```

tras haber creado el entorno qa, pasamos al entorno prod:

```bash   
terraform workspace select prod
```

Y hacemos lo mismo que hicimos con el anterior entorno, solo que esta vez con el entorno prod:

```bash
terraform validate
terraform plan
terraform apply
```

finalmente para borrar todo lo creado ejecutamos los siguientes comandos:
```bash   
terraform destroy
```

## 📋 Requisitos

- Terraform >= 1.5.0
- AWS Provider ~> 5.0
- Node.js 20.x (para desarrollo de Lambdas)
- AWS CLI configurado con credenciales válidas