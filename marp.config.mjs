// Configuración de Marp CLI para ARyS.
// Se autocarga desde la raíz del repo (docker, GitHub Actions y local).
export default {
  // Permite HTML embebido en el markdown (callouts .nota, .cols, .tarjetas).
  html: true,
  // Registra el tema institucional; cada filmina lo referencia con `theme: arys`.
  themeSet: ['./identidad/arys-marp.css'],
};
