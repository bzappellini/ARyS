# Unidad 7 — Sistemas de Autenticación

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Encuadre: de proteger el mensaje a probar la identidad

La Unidad 6 mostró cómo proteger la información. Pero antes de dar acceso a un
recurso hay una pregunta previa: **¿cómo se prueba que alguien es quien dice ser?**
De nada sirve el cifrado si se le abre la puerta a un atacante que **se hace pasar**
por un usuario legítimo. La autenticación es esa puerta.

### 1.1 AAA

Conviene distinguir tres conceptos que suelen confundirse:

- **Authentication (autenticación)** — probar la identidad ("¿quién sos?").
- **Authorization (autorización)** — determinar qué puede hacer una identidad ya
  probada ("¿qué podés hacer?").
- **Accounting (registro/auditoría)** — registrar qué se hizo ("¿qué hiciste?").

Se puede estar autenticado y no estar autorizado para una acción. El modelo Zero
Trust (Unidad 5) exige verificar continuamente las tres.

### 1.2 Los factores

La autenticación se basa en uno o más **factores** de categorías distintas:

- **Algo que se sabe** — contraseña, PIN.
- **Algo que se tiene** — token, smartphone (OTP), llave FIDO2.
- **Algo que se es** — biometría (huella, rostro, iris).
- **Contexto** — ubicación, dispositivo, hora, comportamiento (usado en
  autenticación adaptativa).

La guía conceptual vigente es **NIST SP 800-63B-4** (2025), que reemplazó a la
revisión 3 de 2017 y pasó a titularse *"Authentication and Authenticator
Management"*.

## 2. Contraseñas

El factor "algo que se sabe" es el más usado y el más frágil: se **reutiliza** entre
sitios (una fuga compromete muchas cuentas), se **adivina**, se **roba** y se
**phishea**.

### 2.1 Almacenamiento seguro

Las contraseñas **nunca** se guardan en texto plano. Se almacena un **hash**
(Unidad 6) con dos agregados imprescindibles:

- **Sal (salt)** única por usuario, que derrota las *rainbow tables*.
- **Función lenta y con costo de memoria**, que encarece el crackeo *offline*.

Las tres funciones modernas son **bcrypt** (basada en Blowfish), **scrypt** (RFC
7914, *memory-hard*) y **Argon2** (RFC 9106), ganadora de la *Password Hashing
Competition* y recomendada por defecto en su variante **Argon2id**. Un hash rápido
como SHA-256 "pelado" **no alcanza**: se crackea demasiado rápido.

### 2.2 Ataques

- **Fuerza bruta** — probar todas las combinaciones.
- **Diccionario** — probar listas de contraseñas comunes.
- **Rainbow tables** — hashes precalculados; la sal las anula.
- **Credential stuffing** — reusar credenciales filtradas en muchos sitios.

El crackeo *offline* con John the Ripper o Hashcat (Unidad 3) es la razón por la que
la función de hash debe ser lenta: cada intento cuesta.

### 2.3 Recomendaciones modernas (NIST SP 800-63B-4)

La guía vigente invirtió parte del "sentido común" antiguo:

- Priorizar **longitud** sobre complejidad (mínimo 8, permitir hasta ≥64, admitir
  Unicode y espacios).
- **No** imponer reglas de composición ni preguntas "secretas".
- **No** forzar rotación periódica salvo evidencia de compromiso.
- **Verificar** contra listas de contraseñas comprometidas o comunes.
- Permitir "mostrar contraseña" y el pegado desde gestores.

Buena parte de lo que se enseñaba ("cambiar cada 90 días", "agregar un símbolo") hoy
está **desaconsejado**.

## 3. Kerberos: autenticación basada en tickets

**Kerberos** (RFC 4120) permite **single sign-on sin transmitir la contraseña por la
red**, usando criptografía simétrica y tickets con tiempo de vida. Sus actores:

- **KDC (Key Distribution Center)**, que contiene el **AS (Authentication Server)** y
  el **TGS (Ticket-Granting Server)**.
- El cliente obtiene primero un **TGT (Ticket-Granting Ticket)** del AS.
- Luego presenta el TGT al TGS para conseguir un **service ticket** por cada
  servicio, y con él accede.

Es la base de la autenticación en Active Directory. Ataques clásicos:
**Pass-the-Ticket** (robo y reuso de tickets), **Golden Ticket** (falsificación de
TGT con el hash de la cuenta `krbtgt`), **Silver Ticket** (falsificación de service
ticket) y **Kerberoasting** (solicitar tickets de servicio y crackear *offline* la
clave de cuentas de servicio con SPN).

## 4. Autenticación multifactor (MFA) y OTP

La **MFA** combina **dos o más factores de categorías distintas**: aunque roben la
contraseña, falta el segundo factor. Dos contraseñas no son MFA (misma categoría).

Los **OTP (One-Time Password)** algorítmicos derivan un código de un **secreto
compartido** más un contador o el tiempo, sin necesidad de conexión:

- **HOTP** (RFC 4226) — basado en un **contador** que avanza con cada uso; requiere
  resincronización si cliente y servidor se desfasan.
- **TOTP** (RFC 6238) — variante basada en el **tiempo** (ventanas de ~30 s); es lo
  que usan Google Authenticator, Authy y Microsoft Authenticator. El secreto se
  comparte una sola vez (por QR) y ambos lados calculan el mismo código sin
  comunicarse; si se intercepta un código, ya venció.

### 4.1 OTP por SMS

Recibir el código por SMS es popular pero **débil**: es vulnerable a **SIM
swapping** (secuestro del número), a la intercepción en la red (SS7) y al phishing en
tiempo real. En **NIST SP 800-63B-4**, el OTP por SMS quedó clasificado como
*"restricted authenticator"*: puede usarse, pero con evaluación de riesgo
documentada y plan de migración. Es preferible una app TOTP o una llave FIDO2.

### 4.2 MFA fatigue

Aun con MFA, el ataque de **MFA fatigue / prompt bombing** consiste en que el
atacante, que **ya tiene la contraseña**, dispara decenas de notificaciones push
hasta que la víctima aprueba por cansancio o error (así ocurrió el incidente de
**Uber en 2022**). Mitigaciones: **number matching**, límites de tasa y, en el
fondo, factores **resistentes a phishing** (FIDO2).

## 5. FIDO2, WebAuthn y passkeys

La gran transformación reciente es la autenticación **sin contraseña**, basada en
**criptografía de clave pública** (Unidad 6). El dispositivo genera un **par de
claves por sitio**; la clave privada **nunca sale** del dispositivo y **firma un
desafío** del servidor, que solo almacena la **clave pública** (si lo comprometen,
no hay contraseñas que robar). Es **resistente a phishing por diseño**, porque la
firma está **ligada al origen** (dominio): una web falsa no puede reutilizarla.

- **FIDO2** = **WebAuthn** (API del navegador, W3C) + **CTAP2** (protocolo entre el
  cliente y el authenticator, de la FIDO Alliance). **WebAuthn Level 2** es la
  Recomendación W3C estable (2021); **Level 3** está en *Candidate Recommendation*
  (2026), en camino a Recomendación pero aún no cerrada.
- **Passkeys** — la implementación de consumo masivo: credenciales FIDO
  **sincronizables** por la nube del proveedor (Apple, Google, Microsoft), lo que
  resolvió el problema histórico de recuperación ante pérdida del dispositivo. NIST
  SP 800-63B-4 ya las respalda como *"syncable authenticators"*.

## 6. Federación y SSO en la web

Tres estándares que conviene no mezclar:

- **OAuth 2.0** (RFC 6749) — framework de **autorización/delegación**: permite que
  una app acceda a recursos en nombre del usuario. **No** es autenticación por sí
  mismo.
- **OpenID Connect (OIDC)** — capa de **autenticación** construida sobre OAuth 2.0,
  que agrega el **ID Token** (un JWT que prueba *quién* es el usuario). Regla
  mnemotécnica: **OAuth = qué podés hacer; OIDC = quién sos**. Usar OAuth "pelado"
  para login es el antipatrón clásico.
- **SAML 2.0** (OASIS) — estándar XML de federación **enterprise** (IdP ↔ SP mediante
  *assertions*), muy usado en SSO corporativo y educativo.

*(Como tendencia, existe un borrador **OAuth 2.1** en el IETF que consolida buenas
prácticas como PKCE obligatorio; aún no es RFC publicado.)*

## 7. AAA de red: RADIUS y TACACS+

Protocolos AAA para el acceso a la red y la administración de equipos:

- **RADIUS** (RFC 2865) — sobre **UDP**, combina autenticación y autorización en un
  mismo intercambio y cifra **solo la contraseña**. Uso típico: acceso de usuarios
  (Wi-Fi 802.1X, VPN).
- **TACACS+** (RFC 8907, estatus *Informational*) — de origen Cisco, sobre **TCP**,
  cifra **todo el cuerpo** del paquete y **separa** las tres A en flujos distintos;
  se prefiere para la **administración de dispositivos** (control granular de
  comandos por administrador).

## 8. Tendencia: passwordless y Zero Trust

El eje del cambio es **eliminar la contraseña como secreto compartido**. Las
**passkeys** (FIDO2) se consideran su reemplazo porque son resistentes a phishing, no
reutilizables y no filtrables desde el servidor. En paralelo, **Zero Trust**
(Unidad 5) desplaza la autenticación de un evento único de login hacia la
**verificación continua y adaptativa basada en riesgo**: se reevalúan señales de
dispositivo, ubicación y comportamiento, y se solicita re-autenticación (*step-up*)
cuando el riesgo aumenta.

## 9. Ideas para llevarse

1. AAA: autenticar ≠ autorizar ≠ registrar.
2. Factores: algo que se sabe / se tiene / se es (+ contexto); la MFA los combina.
3. Contraseñas: hash + sal + función lenta (Argon2); NIST cambió las reglas.
4. Kerberos: SSO con tickets sin enviar la contraseña (y sus ataques).
5. OTP: HOTP (contador) y TOTP (tiempo); el SMS es un factor débil.
6. Passkeys / FIDO2: sin contraseña, clave pública, resistente a phishing.
7. Federación: OAuth autoriza, OpenID Connect autentica, SAML federa.

## 10. Referencias

- **NIST SP 800-63B-4** — *Digital Identity Guidelines: Authentication and Authenticator Management* (2025). https://csrc.nist.gov/pubs/sp/800/63/b/4/final
- **NIST SP 800-63-4** — *Digital Identity Guidelines* (suite, niveles AAL). https://csrc.nist.gov/pubs/sp/800/63/4/final
- **RFC 9106** — *Argon2 Memory-Hard Function for Password Hashing*. https://www.rfc-editor.org/rfc/rfc9106
- **RFC 7914** — *The scrypt Password-Based Key Derivation Function*. https://www.rfc-editor.org/rfc/rfc7914
- **RFC 4120** — *The Kerberos Network Authentication Service (V5)*. https://www.rfc-editor.org/rfc/rfc4120
- **RFC 4226** — *HOTP: An HMAC-Based One-Time Password Algorithm*. https://www.rfc-editor.org/rfc/rfc4226
- **RFC 6238** — *TOTP: Time-Based One-Time Password Algorithm*. https://www.rfc-editor.org/rfc/rfc6238
- **W3C WebAuthn Level 2** (Recomendación, 2021). https://www.w3.org/TR/webauthn-2/ · **Level 3** (Candidate Recommendation, 2026). https://www.w3.org/TR/webauthn-3/
- **FIDO Alliance** — FIDO2/CTAP y Passkeys. https://fidoalliance.org/specifications/ · https://fidoalliance.org/passkeys/
- **RFC 6749** — *The OAuth 2.0 Authorization Framework*. https://www.rfc-editor.org/rfc/rfc6749
- **OpenID Connect Core 1.0** (OpenID Foundation). https://openid.net/specs/openid-connect-core-1_0.html
- **SAML 2.0** (OASIS Standard, 2005). https://docs.oasis-open.org/security/saml/v2.0/
- **RFC 2865** — *RADIUS*. https://www.rfc-editor.org/rfc/rfc2865
- **RFC 8907** — *The TACACS+ Protocol* (Informational). https://www.rfc-editor.org/rfc/rfc8907
- **NIST SP 800-207** — *Zero Trust Architecture*. https://csrc.nist.gov/pubs/sp/800/207/final
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
