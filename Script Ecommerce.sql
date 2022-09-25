-- criação do banco de dados para o cenário de e-commerce
create database ecommerce;
use ecommerce;

-- criação da tabela pessoas

create table pessoas(
	idPessoas int auto_increment primary key,
	CPF char(11) not null,
	CNPJ char(14)not null,
	Rz_social varchar(255)not null,
	Nome_completo varchar(45) not null,
	Endereço varchar(45) not null,
	Email varchar(45) not null,
	Dt_nascimento char(10) not null,
	Celular char(15) not null,
    constraint pessoa_juridica_unica unique (CNPJ),
    constraint pessoa_fisica_unica unique (CPF)
    );
    
    alter table pessoas auto_increment = 1;

-- criação da tabela clientes

create table clientes(
	idClientes int auto_increment primary key,
    idCPessoas int,
    CLogin_usuario varchar(45),
	constraint fk_pessoas_clientes foreign key (idCPessoas) references pessoas(idPessoas)
    );
    
    alter table clientes auto_increment = 1;
    
-- criação da tabela pedidos

create table pedidos(
	idPedidos int auto_increment primary key,
    idPClientes int,
    idPCPlat_ecom int,
    Lista_produtos varchar(255),
    Status_pedido enum('Processando', 'Em trânsito', 'Entregue') default 'Processando',
    PCod_rastreio char(13),
    Frete float,
    constraint fk_pedidos_pessoas_clientes foreign key (idPClientes) references clientes(idClientes),
    constraint fk_pedidos_pessoas_clientes_plat_ecom foreign key (idPCPlat_ecom) references plat_ecom(idPlat_ecom)
);

alter table pedidos auto_increment = 1;

-- criação da tabela vendedores

create table vendedores(
	idVendedores int auto_increment primary key,
	idVPessoas int,
    VLogin_usuario varchar(45),
	constraint fk_pessoas_vendedores foreign key (idVPessoas) references pessoas(idPessoas)
);

alter table vendedores auto_increment = 1;

-- criação da tabela anuncios de produtos

create table anun_produtos(
	idAnProdVendedores int,
    idAnProdPlat_ecom int,
    Vendedor varchar(20),
    AnProdCategoria varchar(20),
    Qtde_anunciada char(5),
    AnProdProduto varchar(45),
    AnProdValor varchar(45),
    primary key (idAnProdVendedores, idAnProdPlat_ecom),
    constraint fk_anun_prod_vendedores foreign key (idAnProdVendedores) references vendedores(idVendedores),
    constraint fk_anun_prod_plat_ecom foreign key (idAnProdPlat_ecom) references plat_ecom(idPlat_ecom)
);

alter table anun_produtos auto_increment = 1;

-- criação da tabela plataforma e-commerce

create table plat_ecom(
	idPlat_ecom int auto_increment primary key,
    PlatEcomCategorias varchar(45),
    Descontos varchar(5),
    Frete_gratis bool
);

alter table plat_ecom auto_increment = 1;

-- criação da tabela produtos

create table produtos(
	idProdutos int auto_increment primary key,
    idProdPlat_ecom int,
    idProdFornecedor int,
    idProdEstoque int,
    ProdCategorias varchar(45),
    ProdProdutos varchar(45),
    ProdStatusProdutos enum('disponivel', 'ultimos itens', 'sem estoque'),
    ProdValor varchar(45),
	constraint fk_produtos_plat_ecom foreign key (idProdPlat_ecom) references plat_ecom(idPlat_ecom),
    constraint fk_produtos_fornecedor foreign key (idProdFornecedor) references fornecedor(idFornecedor),
    constraint fk_produtos_estoque foreign key (idProdEstoque) references estoque(idEstoque)
);

alter table produtos auto_increment = 1;

-- criação da tabela fornecedor

create table fornecedor(	
    idFornecedor int auto_increment primary key,
	CNPJ char(14) not null,
	Rz_social varchar(255) not null,
	Endereço varchar(45) not null,
	Email varchar(45) not null,
	Celular char(15) not null,
    constraint fornecedor_unico unique (CNPJ)
);

alter table fornecedor auto_increment = 1;

-- criação da tabela estoque

create table estoque(
	idEstoque int auto_increment primary key,
    Qtde_estoque int default 0,
    Separacao_produto varchar(255),
    Rom_despacho bool,
    Entrada_devolução bool
);

alter table estoque auto_increment = 1;

-- criação da tabela financeiro

create table financeiro(
	idFinanceiro int auto_increment primary key,
    idFinPlat_ecom int,
    idFinEstoque int,
    FCod_rastreio char(13)
    Confirm_frete char(6),
    Metodo_pagto enum('Debito', 'Credito', 'Boleto', 'PIX'),
    Confirm_pagto bool,
    Estorno_devolucao bool,
	constraint fk_financ_plat_ecom foreign key (idFinPlat_ecom) references plat_ecom(idPlat_ecom),
    constraint fk_financ_estoque foreign key (idFinEstoque) references estoque(idEstoque)
);

alter table financeiro auto_increment = 1;

-- criação da tabela entregas_correios

create table entregas_correios(
	idCorreios int auto_increment primary key,
    idCoEstoque int,
    idCoClientes int,
    CCod_rastreio char(13),
    Romaneio enum('tratamento', 'despachado', 'entregue') default 'tratamento',
    Recebto_devolucao bool,
    constraint fk_correios_estoque foreign key (idCoEstoque) references estoque(idEstoque),
	constraint fk_correios_clientes foreign key (idCoClientes) references clientes(idClientes)
);

alter table entregas_correios auto_increment = 1;

-- criação da tabela devolucao

create table devolucao(
	idDevolClientes int,
    idDevolFinanceiro int,
    Pedido_devolucao varchar(255),
    Confim_devol_produto bool,
    Estorno_financeiro bool,
    primary key (idDevolClientes, idDevolFinanceiro),
    constraint fk_devol_clientes foreign key (idDevolClientes) references clientes(idClientes),
	constraint fk_devol_financeiro foreign key (idDevolFinanceiro) references financeiro(idFinanceiro)
);

alter table devolucao auto_increment = 1;

-- confirmação de que todos os constraints foram considerados

show databases;
use information_schema;
show tables;
desc referential_constraints;
select * from referential_constraints where constraint_schema = 'ecommerce';


-- inserção de dados no BD

use ecommerce;
show tables;

-- persistência de dados em pessoas

insert into pessoas(CPF, CNPJ, Rz_social, Nome_completo, Endereço, Email, Dt_nascimento, Celular)
	values (30343708933,25450191000253,'DJ_Penderro','Denilson Diaiow','Rua Escondidinho, 37','denilson@gmail.com','1970/06/13',14947536626),
	       (30133378210,23144012000374,'Didididigital','Venilton Vuwow','Av Ventania 256','venilton@aol.com','1972/02/22',19966612666),
           (20134598633,34555672000123,'LostInDB','July Forgot','Tv Unknown 77','juliana@bol.com.br','1990/09/07',4748630911),
           (12346934422,30340280000122,'DarkWeb','Otavio Reis','Tv Gamer 169','otavio.pikled@hotmail.com',1993/01/01,5340566712),
           (14432323205,22344566000143,'ICQ_king','Mark Zucky','Av Timeline Disgrace 666','mark.zuccini@yahoo.com','1995/11/12',11981283744),
           (11034578234,20333456000134,'Offline2030','Steve Lah','Rua Changrilah 43','steve.lah@toloka.com','1976/12/24',12956345533);

-- persitência de dados em clientes

insert into clientes(CLogin_usuario)
	values ('DJ_Penderro'),
		   ('Didididigital'),
           ('LostInDB'),
           ('DarkWeb'),
           ('ICQ_King'),
           ('Offline2030');
           
-- persistência de dados em vendedores

insert into vendedores(VLogin_usuario)
	values ('DarkWeb'),
		   ('ICQ_King'),
           ('Offline2030'),
           ('Didididigital');
           
-- Persistência de dados em anúncio de produtos

insert into anun_produtos(Vendedor, AnProdCategoria, Qtde_anunciada, AnProdProduto, AnProdValor)
	values ('DarkWeb','Jogos','10','GTA V pendrive',49.99),
		   ('Offline2030','Telefonia','1000','Combo Samsung+Fone de ouvido',2999.00),
           ('ICQ_King','Informatica','5000','MetaversoGoogle',10349.99),
           ('Didididigital','Tech','100','DioPRO',34.90),
           ('DarkWeb','Tech','300','Github pronto 1000 repositorios',69.99),
           ('Offline2030','Telefonia','1000', 'iphoneXR 26',15699.00);

-- persistência de dados em produtos

insert into produtos(ProdCategorias, ProdProdutos, ProdStatusProdutos, ProdValor)
	values ('Telefonia','Samsung Galaxy S37 FE','disponivel',6999.00),
           ('Informatica','Gyrocam 8K Nosferattus Vibrus 5000','disponivel',13549.10),    
		   ('Esportes','ActionCam 12k 4D','disponivel',299.00),
           ('Roupa','Blusa Boliviana Premium XXL','disponivel',2.99),
           ('Alimento','Oleo DiBacalhau 13.000 Hg enriched','ultimos itens',59.99),
           ('Alimento','Cogumelo do Sol + Ginseng 8000 Super','ultimos itens',133.99),
           ('Tenis','Adidas LucasPuig Ultralust Brazil Edition','ultimos itens',2899,99),
           ('Alimento','Leite condensado governo especial edition','sem estoque',3.00);

-- persistência de dados em pedidos

insert into pedidos(Lista_produtos, Status_pedido, PCod_rastreio, Frete)
	values ('Cogumelo do Sol, Oleo DiBacalhau 13.000 Hg enriched, DioPRO','Em Trânsito','EX123456789BR',26.77),
		   ('Blusa Boliviana Premium XXL, ActionCam 12k 4D, GTA V pendrive','Processando','BA234567890BR',19,80),
           ('Adidas LucasPuig Ultralust Brazil Edition, Gyrocam 8K Nosferattus Vibrus 5000','Em Trânsito','FU452678923BR',33.90),
           ('iphoneXR 26, MetaversoGoogle, Adidas LucasPuig Ultralust Brazil Edition, Cogumelo do Sol + Ginseng 8000 Super','Entregue','FX234819204BR',58.73),
           ('Samsung Galaxy S37 FE','Processando','WQ239561948BR',110.00),
           ('Oleo DiBacalhau 13.000 Hg enriched, Github pronto 1000 repositorios','Entregue','WZ271938273BR',8.89),
           ('Combo Samsung+Fone de ouvido, ActionCam 12k 4D','Processando','ER129348392BR',12.33);

-- persistência de dados em plataforma e-commerce

insert into plat_ecom(PlatEcomCategorias, Descontos, Frete_gratis)
	values ('Telefonia','-8%',true),
           ('Tech','-55%',true),
           ('Informatica','-13%',false),
           ('Jogos','-5%',true),
           ('Esportes','-12%',false),
           ('Alimento','-9%',false),
           ('Roupa','-70%',false),
           ('Tenis','-15%',false);
           
-- persistência de dados em fornecedor

insert into fornecedor(CNPJ, Rz_social, Endereço, Email, Celular)
	values (23144012000374,'Didididigital','Av Ventania 256','venilton@aol.com',19966612666),
		   (25450191000253,'DJ_Penderro','Rua Escondidinho, 37','denilson@gmail.com',14947536626),
           (20333456000134,'Offline2030','Rua Changrilah 43','steve.lah@toloka.com',12956345533),
           (22344566000144,'ICQ_king','Av Timeline Disgrace 666','mark.zuccini@yahoo.com',11981283744),
           (25453998000123,'Obi-wan2049','Av Cereser 1580','obi_tamagochi666@obicorp.com',83943032244);

-- persistência de dados em estoque

insert into estoque(Qtde_estoque, Separacao_produto, Rom_despacho, Entrada_devolução)
	values (484,'Blusa Boliviana Premium XXL',false,false),
		   (123,'ActionCam 12k 4D',false,false),
           (50,'GTA V pendrive',false,false),
           (234,'Samsung Galaxy S37 FE',false,false),
           (1023,'Combo Samsung+Fone de ouvido',false,false),
           (598,'ActionCam 12k 4D',false,false),
           (2347,'Cogumelo do Sol + Ginseng 8000 Super',false,true),
		   (10101,'Oleo DiBacalhau 13.000 Hg enriched',true,false),
		   (15,'Adidas LucasPuig Ultralust Brazil Edition',true,false),
		   (267,'Gyrocam 8K Nosferattus Vibrus 5000',true,false),
           (23,'iphoneXR 26',true,false),
           (247,'MetaversoGoogle',true,false);
        
-- persistência de dados em financeiro

insert into financeiro(FCod_rastreio, Confirm_frete, Metodo_pagto, Confirm_pagto, Estorno_devolucao)
	values ('EX123456789BR',26.77,'Boleto',true,true),
		   ('BA234567890BR',19,80,'PIX',true,false),
           ('FU452678923BR',33.90,'Debito',true,false),
           ('FX234819204BR',58.73,'Credito',true,false),
           ('WQ239561948BR',110.00,'Credito',true,false),
           ('WZ271938273BR',8.89,'Debito',true,false),
           ('ER129348392BR',12.33,'Credito',true,false);

-- persistência de dados em entregas correios

insert into entregas_correios(Romaneio, CCod_rastreio, Recebto_devolucao)
	values ('despachado','EX123456789BR',true),
		   ('tratamento','BA234567890BR',false),
           ('despachado','FU452678923BR',false),
           ('entregue','FX234819204BR',false),
           ('tratamento','WQ239561948BR',false),
           ('entregue','WZ271938273BR',false),
           ('tratamento','ER129348392BR',false);

-- persistência de dados em devolução

insert into devolucao(Pedido_devolucao, Confim_devol_produto, Estorno_financeiro)
	values ('desistência da compra',true,true);


-- queries complexas para recuperação de dados


-- relação de clientes com a quantidade de pedidos em aberto e o status

select * from anun_produtos;
select count(*) from pessoas;
select * from pessoas pe, clientes c where idPessoas = idClientes;
select * from clientes c, pedidos po where idClientes = idPClientes;

select Nome_completo, idPedidos, Status_pedido  from pessoas pe, pedidos po where idPessoas = idPClientes;

-- recuperação de dados intersecionados entre as tabelas clientes e pedidos

select * from pedidos;
select * from pessoas pe, clientes c where idPessoas = idClientes;
select * from clientes c INNER JOIN pedidos p ON c.idClientes = p.idPClientes;

-- recuperar lista de produtos anunciados por vendedores

select count(*) from anun_produtos;
select * from pessoas pe, vendedores v where idPessoas = idVPessoas;
select * from vendendores v INNER JOIN anun_produtos a ON v.idVendedores = a.idAnProdVendedores;

select Nome_completo, VLogin_ususario, AnProdCategoria, Qtde_anunciada, AnProdProduto, AnProdValor from anun_produtos a, vendedores v where a.idAnProdVendedores = v.idVendedores;

-- recuperação de dados intersecionados entre produtos e plataforma e-commerce

select * from produtos;
select ProdCategorias, ProdProdutos, ProdStatusProdutos, ProdValor from produtos pr LEFT OUTER JOIN plat_ecom pl ON pr.idProdutos = pl.idProdPlat_ecom
GROUP BY ProdCategorias
HAVING Frete_gratis = true;




