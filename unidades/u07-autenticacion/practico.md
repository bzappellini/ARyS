# Trabajo Práctico 7 — Autenticación

> ARyS · IF046 · UNPSJB Trelew. Modalidad: laboratorio guiado + informe.
> Duración estimada: una clase práctica (3 h) + entrega.

## Objetivos

1. Entender por qué las contraseñas se guardan **hasheadas con sal** y por qué la
   función debe ser **lenta**.
2. **Crackear** un hash débil vs. uno fuerte y medir la diferencia.
3. Configurar y validar un **TOTP** (segundo factor).
4. Comprender el flujo **FIDO2 / passkey** con una demo, y comparar factores.

> Todo se hace con **hashes y cuentas propias**, en el laboratorio. No se atacan
> credenciales de terceros.

---

## Parte A — Cómo se guarda una contraseña

```bash
# Un hash RÁPIDO (lo que NO hay que usar para contraseñas)
echo -n "Primavera2026" | sha256sum

# Un hash LENTO con sal (bcrypt/yescrypt vía mkpasswd)
sudo apt install whois          # provee mkpasswd
mkpasswd -m bcrypt "Primavera2026"
mkpasswd -m bcrypt "Primavera2026"   # ¡corré dos veces!
```

**Consignas A:**
1. Corré `mkpasswd -m bcrypt` **dos veces** con la misma contraseña. ¿Por qué dan
   resultados **distintos**? (pista: la sal).
2. Explicá por qué un `sha256sum` **no** sirve para almacenar contraseñas, aunque sea
   un hash. Relacionalo con "el hash tiene que ser lento".
3. ¿Qué agrega **Argon2** sobre bcrypt? (pista: costo de memoria).

---

## Parte B — Crackeo: débil vs. fuerte

Generá dos hashes y tratá de crackearlos con **John** (reusando lo de la Unidad 3),
en tu propia máquina:

```bash
# Hash de una contraseña DÉBIL (está en rockyou) y una FUERTE
mkpasswd -m bcrypt "123456"        > hashes.txt
mkpasswd -m bcrypt "correct horse battery staple" >> hashes.txt

# Intentar crackear por diccionario
john --format=bcrypt --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
john --show --format=bcrypt hashes.txt
```

**Consignas B:**
1. ¿Cuál de las dos cayó y cuál no? ¿Por qué la **longitud** le gana a la
   complejidad? (relacionalo con la recomendación de NIST 800-63B-4).
2. ¿Por qué la **sal** no impide el crackeo por diccionario, pero sí las rainbow
   tables?

---

## Parte C — Segundo factor: TOTP

Simulá el par app-servidor con `oathtool`:

```bash
sudo apt install oathtool

# Generar un secreto (en base32) — esto es lo que iría en el QR
SECRET="JBSWY3DPEHPK3PXP"

# Calcular el TOTP actual (lo que mostraría tu app)
oathtool --totp --base32 "$SECRET"
# Esperá 30 segundos y volvé a calcular
oathtool --totp --base32 "$SECRET"
```

**Consignas C:**
1. Mostrá dos códigos calculados con **más de 30 s** de diferencia: ¿cambió? ¿Por qué?
2. Si un atacante **intercepta** un código TOTP, ¿le sirve un minuto después? Justificá.
3. ¿Qué diferencia a **HOTP** de **TOTP** en el "contador"?

---

## Parte D — Passkeys y comparación de factores

1. Entrá a la demo oficial **https://webauthn.io** desde tu navegador y **registrá y
   usá una passkey** (huella, PIN del dispositivo o llave). Documentá el flujo con
   capturas.
2. **Consigna D.1.** ¿En qué momento se usó tu **clave privada** y qué guardó el
   servidor? ¿Por qué una web de phishing **no** podría reutilizar tu passkey?
3. **Consigna D.2.** Completá una tabla comparando **contraseña · TOTP · passkey**
   según: ¿se puede phishear?, ¿se reutiliza?, ¿se filtra desde el servidor?
4. **Consigna D.3.** Explicá la diferencia entre **OAuth 2.0** y **OpenID Connect**
   con el botón "iniciar sesión con Google": ¿cuál prueba *quién sos*?

---

## Entrega y evaluación

- **Formato:** un único PDF con las partes A–D. Nombre: `TP7_ApellidoNombre.pdf`.
- **Vía:** campus virtual UNPSJB.
- **Criterios de corrección:**
  - Hashing de contraseñas y rol de la sal comprendidos (25 %).
  - Crackeo débil vs. fuerte e interpretación (longitud, sal) (25 %).
  - TOTP configurado e interpretado correctamente (25 %).
  - Passkey/FIDO2 y comparación de factores + OAuth vs OIDC (20 %).
  - Claridad y prolijidad del informe (5 %).

## Para investigar (opcional, suma)

- **Kerberoasting**: ¿por qué las cuentas de servicio con SPN son un blanco, y cómo
  se mitiga? (relacionalo con Kerberos y el crackeo offline).
- **MFA fatigue**: cómo funciona el *number matching* y por qué frena el prompt
  bombing.
- **RADIUS vs TACACS+**: ¿por qué TACACS+ se prefiere para administrar equipos de red?
