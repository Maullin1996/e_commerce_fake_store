String categorySelected(String selectedCategory) {
  switch (selectedCategory) {
    case 'electronics':
      return '/category/electronics';
    case 'jewelery':
      return '/category/jewelery';
    case "men's clothing":
      return "/category/men's clothing";
    case "women's clothing":
      return "/category/women's clothing";
  }
  return '';
}
