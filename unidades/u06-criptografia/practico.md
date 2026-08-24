# Trabajo Práctico 6 — Criptografía aplicada

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Usar criptografía **simétrica** y **asimétrica** con herramientas estándar
   (OpenSSL, GnuPG).
2. Generar un par de claves, **cifrar** para un destinatario y **firmar** un
   documento; **verificar** ambos.
3. Inspeccionar un **certificado TLS** real y reconocer la cadena de confianza.
4. Comprobar el concepto de **hash** y la **avalancha**.

> Todo se hace con **material propio** y contra servicios públicos que **permiten**
> la inspección de su certificado (lo que hace tu navegador en cada visita).

---

## Parte A — Simétrico y hash con OpenSSL

```bash
# Cifrado simétrico AEAD (AES-256-GCM) con una passphrase
echo "Mensaje secreto de la catedra" > mensaje.txt
openssl enc -aes-256-gcm -pbkdf2 -salt -in mensaje.txt -out mensaje.enc
# Descifrar
openssl enc -d -aes-256-gcm -pbkdf2 -in mensaje.enc -out descifrado.txt
cat descifrado.txt

# Hash: efecto avalancha
echo -n "catedra"  | sha256sum
echo -n "Catedra"  | sha256sum
```

**Consignas A:**
1. Mostrá que `mensaje.enc` es ilegible y que se recupera el original.
2. Compará los dos hashes SHA-256: cambiar **una sola letra**, ¿cuánto cambia el
   resultado? ¿Cómo se relaciona esto con la detección de integridad?
3. ¿Qué aporta el modo **GCM** frente a un modo de solo cifrado? (pista: AEAD).

---

## Parte B — Asimétrico y firma con GnuPG

```bash
# Generar un par de claves (elegí RSA 3072 o, mejor, ECC/Ed25519)
gpg --full-generate-key

# Exportar tu clave pública para compartirla
gpg --armor --export "Tu Nombre" > mi_publica.asc

# Firmar un documento (firma separada)
echo "Acta de la clase 6" > acta.txt
gpg --armor --detach-sign acta.txt      # genera acta.txt.asc

# Verificar la firma
gpg --verify acta.txt.asc acta.txt
```

**Consignas B:**
1. Mostrá la verificación **exitosa** de la firma. Después **modificá** `acta.txt`
   (cambiá una palabra) y volvé a verificar: ¿qué pasa y **por qué**?
2. Con tus palabras y el diagrama de las filminas: ¿con qué clave se **firma** y con
   cuál se **verifica**?
3. ¿Qué tres propiedades de la Unidad 1 te da la firma digital?

---

## Parte C — Cifrar para un destinatario

Intercambiá claves públicas con un compañero (o generá una segunda clave de prueba).

```bash
# Importar la clave pública del destinatario
gpg --import compa_publica.asc

# Cifrar un archivo para ESE destinatario (solo él podrá abrirlo)
gpg --armor --encrypt --recipient "Nombre del Compa" acta.txt   # -> acta.txt.asc

# El destinatario descifra con SU clave privada
gpg --decrypt acta.txt.asc
```

**Consigna C.** Explicá por qué vos, que cifraste el archivo, **no** podés
descifrarlo con tu propia clave. ¿Con qué clave se cifró y con cuál se descifra?

---

## Parte D — Un certificado TLS real (PKI)

```bash
# Ver el certificado que presenta un sitio y su cadena
openssl s_client -connect www.unp.edu.ar:443 -servername www.unp.edu.ar </dev/null 2>/dev/null \
  | openssl x509 -noout -issuer -subject -dates

# Ver la cadena completa
echo | openssl s_client -connect www.unp.edu.ar:443 -showcerts 2>/dev/null | grep -E "s:|i:"
```

**Consignas D:**
1. ¿Quién **emitió** el certificado (issuer) y **para quién** (subject)? ¿Cuál es su
   período de validez?
2. Identificá la **cadena de confianza** (servidor → intermedia → raíz) con el
   diagrama de PKI de las filminas.
3. ¿Por qué tu navegador **confía** en ese certificado sin haberlo visto antes?

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A–D. Nombre: `TP6_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Cifrado simétrico y hash correctos e interpretados (25 %).
  - Generación de claves, firma y verificación (incluida la firma inválida) (30 %).
  - Cifrado asimétrico para un destinatario, bien explicado (20 %).
  - Lectura del certificado TLS y de la cadena de confianza (20 %).
  - Claridad y prolijidad del informe (5 %).

## Para investigar (opcional, suma)

- Diferencia entre **RSA** y **Ed25519** al generar la clave: tamaño, velocidad.
- Qué es **forward secrecy** y por qué TLS 1.3 lo exige (relacionalo con "harvest now,
  decrypt later").
- **Esteganografía**: escondé un mensaje en una imagen con `steghide` y discutí en qué
  se diferencia de cifrarlo.
- **Criptografía post-cuántica**: ¿por qué la cuántica amenaza a RSA/ECC pero **no**
  rompe a AES? Investigá FIPS 203 (ML-KEM).
