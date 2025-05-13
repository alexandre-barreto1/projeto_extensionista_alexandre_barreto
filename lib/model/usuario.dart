class usuario {
  final int id;
  final String email;
  final String nome;
  final String user;
  final String senha;


  const usuario(this.nome, this.senha, {required this.id, required this.email, required this.user});
}