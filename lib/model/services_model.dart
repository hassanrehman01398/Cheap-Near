class ServicesModel{
  String id;
  String image;
  String name;
  String price;
  String locations;
  String type;
  String description;

  ServicesModel(this.id,this.image,this.name,this.price,this.locations,this.type,this.description);
}

List<ServicesModel> services = [
  ServicesModel("1","https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8c2VydmljZXN8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60", "Packing", "200 \$", "Karachi Pakistan", "Work", "A very good service"),
  ServicesModel("2","https://marketing-insider.eu/wp-content/uploads/2015/06/Service-Characteristics-of-Services.jpg", "Packing", "200 \$", "Karachi Pakistan", "Work", "A very good service"),
  ServicesModel("3","https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8c2VydmljZXN8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60", "Packing", "200 \$", "Karachi Pakistan", "Work", "A very good service"),
  ServicesModel("4","https://marketing-insider.eu/wp-content/uploads/2015/06/Service-Characteristics-of-Services.jpg", "Packing", "200 \$", "Karachi Pakistan", "Work", "A very good service"),
  ServicesModel("5","https://marketing-insider.eu/wp-content/uploads/2015/06/Service-Characteristics-of-Services.jpg", "Packing", "200 \$", "Karachi Pakistan", "Work", "A very good service"),
  ServicesModel("6","https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8c2VydmljZXN8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60", "Packing", "200 \$", "Karachi Pakistan", "Work", "A very good service"),
];