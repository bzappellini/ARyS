# Unidad 6 — Criptografía

> Material teórico de acompañamiento. Complementa las filminas y la clase.
> ARyS · IF046 · UNPSJB Trelew.

## 1. Encuadre: la defensa que atraviesa todo

A lo largo del curso, la misma respuesta reaparece: ante el sniffing (Unidad 4), se
**cifra** el tráfico; si el firewall falla (Unidad 5), los datos siguen **cifrados**;
si roban el disco (Unidad 2), el **cifrado de disco** los protege. La criptografía
parte de una premisa: **el canal es hostil**, y aun así la información debe quedar
protegida. Es la última línea de defensa y la que sostiene a todas las demás.

Provee, con fundamento matemático, los pilares de la Unidad 1:
**confidencialidad** (cifrado), **integridad** (hash), **autenticidad** y **no
repudio** (firma digital).

### 1.1 El principio de Kerckhoffs

Un sistema criptográfico debe ser seguro **aunque todo sobre él sea público, excepto
la clave**. La seguridad vive en la **clave**, no en mantener secreto el algoritmo;
por eso los algoritmos sólidos son **públicos y auditados** por la comunidad
mundial. La consecuencia práctica es una regla de oro: **no se inventa criptografía
propia**; se usan algoritmos estándar, revisados durante décadas.

## 2. Criptografía simétrica

Usa una **misma clave secreta** para cifrar y descifrar. Es rápida, pero plantea el
problema de **cómo compartir la clave** de forma segura.

- **Cifrado de bloque** — procesa bloques de tamaño fijo. El estándar es **AES**
  (**FIPS 197**, actualizado en 2023 solo editorialmente).
- **Cifrado de flujo** — genera un *keystream* que se combina (XOR) con el texto;
  ejemplo moderno: **ChaCha20**.
- **AEAD** (*Authenticated Encryption with Associated Data*) — el estándar actual:
  cifra **y** autentica en una sola operación. Los dos AEAD dominantes son
  **AES-GCM** (**NIST SP 800-38D**) y **ChaCha20-Poly1305** (**RFC 8439**). Es lo que
  usan TLS 1.3, SSH y WireGuard.

**Algoritmos deprecados**: **DES** y **3DES/TDEA** están prohibidos para protección
desde el 1/1/2024 (**NIST SP 800-131A Rev. 2**), y **RC4** está roto y prohibido en
TLS (**RFC 7465**). La criptografía **caduca**: parte del oficio profesional es
reconocer qué quedó obsoleto.

## 3. Funciones de hash

Producen una **huella de tamaño fijo** de cualquier entrada; son la base de la
integridad y de la firma digital. La propiedad esencial es la **resistencia a
colisiones** (debe ser inviable hallar dos entradas con el mismo hash).

- **SHA-2** (SHA-256, SHA-512) — **FIPS 180-4**, el más usado.
- **SHA-3** (Keccak) — **FIPS 202**, con una construcción de esponja distinta a
  SHA-2, como alternativa robusta.
- **BLAKE2 / BLAKE3** — funciones muy rápidas (**RFC 7693** / especificación oficial
  de BLAKE3).

**Rotos**: **MD5** tiene colisiones prácticas (**RFC 6151**) y **SHA-1** fue
quebrado con el ataque **SHAttered** (Google/CWI, 2017); NIST fijó su **eliminación
total para 2030**. Encontrar MD5 o SHA-1 protegiendo algo hoy es un hallazgo de
auditoría.

## 4. Criptografía asimétrica

Usa un **par** de claves (pública y privada): lo que cifra una, solo lo descifra la
otra. Resuelve el problema de compartir la clave, a costa de ser más lenta.

- **RSA** — se apoya en la dificultad de **factorizar** números grandes; claves de
  2048–4096 bits (Rivest-Shamir-Adleman, 1978).
- **ECC (curva elíptica)** — ofrece la misma seguridad con claves **mucho más
  pequeñas** (una curva de 256 bits equivale aproximadamente a RSA-3072); es más
  rápida y liviana.

### 4.1 Diffie-Hellman y forward secrecy

**Diffie-Hellman** (1976) permite que dos partes **acuerden una clave secreta
compartida** intercambiando mensajes por un canal **público**, sin que un espía
pueda deducirla. Es la base del cifrado en tránsito. Con claves **efímeras** (una
por sesión, **ECDHE**) se obtiene **forward secrecy**: comprometer la clave de largo
plazo no permite descifrar las sesiones **pasadas**. TLS 1.3 lo exige.

### 4.2 Curvas modernas

El estándar de facto son las curvas de Bernstein, por rendimiento y resistencia a
canales laterales: **X25519** para intercambio de claves (**RFC 7748**) y
**Ed25519** para firma (EdDSA, **RFC 8032**). Una clave pública Ed25519 ocupa 32
bytes y la firma 64; EdDSA ya fue aprobado por NIST en **FIPS 186-5**.

## 5. Cifrado híbrido

En la práctica no se usa criptografía pura de un tipo, sino la **combinación**: la
**asimétrica / DH** se emplea para **acordar** una clave de sesión (y autenticar), y
la **simétrica (AEAD)** para **cifrar los datos** rápidamente. Así funciona todo
HTTPS: la asimétrica resuelve el problema de compartir la clave; la simétrica hace el
trabajo pesado.

## 6. Firma digital

La firma digital usa la **clave privada** del firmante para producir, a partir del
**hash** del documento, un valor que cualquiera puede verificar con la **clave
pública**. Garantiza **integridad**, **autenticidad** y **no repudio**.

- Estándar técnico: **FIPS 186-5** (2023), que ya **no aprueba DSA para generar**
  firmas e incorpora **EdDSA** (Ed25519/Ed448) y una variante determinista de ECDSA.
- En **Argentina**, la **Ley 25.506 de Firma Digital** (2001) le otorga **valor
  jurídico equivalente** a la firma manuscrita. Conviene distinguir la "firma
  digital" (con certificado y validez legal plena) de la "firma electrónica" simple:
  la ley las diferencia.

## 7. PKI y certificados

La **Infraestructura de Clave Pública (PKI)** liga una **identidad** a una **clave
pública** mediante **certificados X.509** (**RFC 5280**) firmados por una **Autoridad
Certificante (CA)**, formando una **cadena de confianza** hasta una raíz en la que el
navegador o el sistema operativo ya confía. Si se confía en la raíz y cada eslabón
firma al siguiente, puede verificarse la identidad de un servidor desconocido.

- **ACME** (**RFC 8555**) y **Let's Encrypt** automatizaron y masificaron la emisión
  de certificados, impulsando la adopción universal de HTTPS.
- **Certificate Transparency** (**RFC 9162**, v2) mantiene registros públicos
  *append-only* para detectar certificados mal emitidos.

Es la PKI la que, autenticando al servidor y habilitando el cifrado, hace que un
sniffer (Unidad 4) solo vea tráfico ilegible.

## 8. Correo cifrado: PGP y S/MIME

Dos estándares para cifrar y firmar correo de extremo a extremo:

- **OpenPGP / GnuPG** — usa una **red de confianza** (*web of trust*). Se modernizó
  con el **RFC 9580** (2024), que obsoleta al histórico RFC 4880 e incorpora curvas
  modernas y AEAD.
- **S/MIME** (**RFC 8551**) — se apoya en **certificados X.509 / PKI**.

En ambos, se cifra con la clave **pública** del destinatario (solo él puede leer) y
se firma con la clave **privada** propia (prueba de autoría).

## 9. Esteganografía

Mientras la criptografía oculta el **contenido** de un mensaje (dejando ver que hay
comunicación cifrada), la **esteganografía** oculta la **existencia** misma del
mensaje, escondiéndolo dentro de una imagen, audio o video. Son técnicas
**complementarias**: puede cifrarse un mensaje y además esconderlo. Aparece en marcas
de agua (*watermarking*), exfiltración de datos y canales encubiertos. Referencia
conceptual clásica: Petitcolas, Anderson & Kuhn, *Information Hiding — A Survey*
(1999).

## 10. Protocolos

Todos ensamblan los mismos ladrillos (DH para acordar clave, AEAD para cifrar,
firma/certificados para autenticar); cambia el ensamblaje:

- **TLS 1.3** — el candado de la web; solo admite cifradores AEAD y exige forward
  secrecy. Definido en **RFC 8446** (2018) y **actualizado por el RFC 9846** (2026),
  una revisión aclaratoria que mantiene el mismo protocolo y número de versión.
- **SSH** — administración remota segura; arquitectura en **RFC 4251** (transporte en
  RFC 4253).
- **IPsec** — VPN a nivel de red; arquitectura en **RFC 4301**, con intercambio de
  claves **IKEv2** (**RFC 7296**).
- **WireGuard** — VPN moderno y minimalista (Curve25519 + ChaCha20-Poly1305), en el
  kernel Linux desde la versión 5.6 (Donenfeld, NDSS 2017).

## 11. Criptografía post-cuántica (PQC)

Casi toda la criptografía **asimétrica** actual (RSA, ECC) se apoya en problemas que
una **computadora cuántica** suficientemente grande resolvería eficientemente con el
**algoritmo de Shor** (1994). Aunque esa máquina todavía no existe, la estrategia
**"harvest now, decrypt later"** —capturar hoy tráfico cifrado para descifrarlo
cuando la cuántica esté disponible— vuelve **urgente migrar ya**.

En **agosto de 2024**, NIST publicó los primeros tres estándares de criptografía
post-cuántica, diseñados para resistir a Shor:

- **FIPS 203 — ML-KEM** (basado en **Kyber**): mecanismo de encapsulado de claves,
  reemplazo del intercambio RSA/ECDH.
- **FIPS 204 — ML-DSA** (basado en **Dilithium**): firma digital.
- **FIPS 205 — SLH-DSA** (basado en **SPHINCS+**): firma basada solo en hash, como
  esquema de respaldo conservador.

Nota importante: la criptografía **simétrica** (AES) y las funciones de **hash** no
se rompen con la cuántica; solo se debilitan y se compensan con claves y salidas más
largas. El impacto fuerte recae sobre la **asimétrica**.

## 12. Ideas para llevarse

1. La criptografía asume el canal hostil y protege igual.
2. Kerckhoffs: la seguridad vive en la clave; no inventes tu propio cripto.
3. Simétrica (AES/AEAD) rápida; asimétrica (RSA/ECC) resuelve compartir la clave.
4. En la práctica se usa cifrado híbrido: DH acuerda, simétrica cifra (así es TLS).
5. Hash para integridad; firma digital para autenticidad y no repudio (Ley 25.506).
6. La PKI liga identidad y clave pública; es el candado de la web.
7. Se viene la criptografía post-cuántica (FIPS 203/204/205, 2024).

## 13. Referencias

- **FIPS 197** — *Advanced Encryption Standard (AES)* (2001, upd. 2023). https://csrc.nist.gov/pubs/fips/197/final
- **NIST SP 800-38D** — *GCM and GMAC*. https://csrc.nist.gov/pubs/sp/800/38/d/final
- **RFC 8439** — *ChaCha20 and Poly1305 for IETF Protocols*. https://www.rfc-editor.org/info/rfc8439/
- **NIST SP 800-131A Rev. 2** — *Transitioning the Use of Cryptographic Algorithms and Key Lengths*. https://csrc.nist.gov/pubs/sp/800/131/a/r2/final
- **RFC 7465** — *Prohibiting RC4 Cipher Suites*. https://www.rfc-editor.org/info/rfc7465/
- **FIPS 180-4** — *Secure Hash Standard (SHS)*. https://csrc.nist.gov/pubs/fips/180-4/upd1/final
- **FIPS 202** — *SHA-3 Standard*. https://csrc.nist.gov/pubs/fips/202/final
- **RFC 6151** — *Updated Security Considerations for MD5*. https://www.rfc-editor.org/info/rfc6151/ · SHAttered: https://shattered.io/
- **RFC 7748** — *Elliptic Curves for Security (X25519)*. https://www.rfc-editor.org/info/rfc7748/
- **RFC 8032** — *EdDSA (Ed25519)*. https://www.rfc-editor.org/info/rfc8032/
- **FIPS 186-5** — *Digital Signature Standard (DSS)* (2023). https://csrc.nist.gov/pubs/fips/186-5/final
- **Ley 25.506** (Argentina) — *Firma Digital* (2001). https://servicios.infoleg.gob.ar/infolegInternet/verNorma.do?id=70749
- **RFC 5280** — *X.509 PKI Certificate and CRL Profile*. https://www.rfc-editor.org/info/rfc5280/
- **RFC 8555** — *ACME*. https://www.rfc-editor.org/info/rfc8555/ · Let's Encrypt: https://letsencrypt.org/docs/
- **RFC 9162** — *Certificate Transparency v2.0*. https://www.rfc-editor.org/info/rfc9162/
- **RFC 9580** — *OpenPGP* (2024). https://www.rfc-editor.org/info/rfc9580/ · GnuPG: https://gnupg.org/
- **RFC 8551** — *S/MIME v4.0*. https://www.rfc-editor.org/info/rfc8551/
- **RFC 8446** — *TLS 1.3* (2018). https://www.rfc-editor.org/info/rfc8446/ · **RFC 9846** — *TLS 1.3* (2026). https://www.rfc-editor.org/info/rfc9846/
- **RFC 4251** — *SSH Protocol Architecture*. https://www.rfc-editor.org/info/rfc4251/
- **RFC 4301** — *Security Architecture for IP (IPsec)*. https://www.rfc-editor.org/info/rfc4301/ · IKEv2: RFC 7296.
- **WireGuard** — Donenfeld, *WireGuard: Next Generation Kernel Network Tunnel* (NDSS 2017). https://www.wireguard.com/papers/wireguard.pdf
- Petitcolas, Anderson & Kuhn — *Information Hiding: A Survey* (1999).
- **Shor** — *Polynomial-Time Algorithms for Prime Factorization and Discrete Logarithms on a Quantum Computer* (1997). https://arxiv.org/abs/quant-ph/9508027
- **FIPS 203 / 204 / 205** — *ML-KEM / ML-DSA / SLH-DSA* (NIST, 2024). https://csrc.nist.gov/pubs/fips/203/final · /204/final · /205/final
- W. Stallings — *Fundamentos de Seguridad en Redes* (bibliografía de cátedra).
