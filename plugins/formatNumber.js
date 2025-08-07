export default (_, inject) => {
  inject('formatNumber', (value) => {
    if (value == null || value === '') return '';
    return Number(value)
      .toString()
      .replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  });
};
