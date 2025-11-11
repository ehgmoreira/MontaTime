String levelLabel(int level) {
  switch (level) {
    case 1:
      return 'Iniciante';
    case 2:
      return 'Básico';
    case 3:
      return 'Intermediário';
    case 4:
      return 'Avançado';
    default:
      return '—';
  }
}
