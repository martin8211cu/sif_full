/*==============================================================*/
/* DBMS name:      Sybase AS Enterprise 12.5.1                  */
/* Created on:     02/06/2004 06:58:23 p.m.                     */
/*==============================================================*/


alter table Votos
   drop constraint FK_VOTOS_REFERENCE_CONCURSA
go


if exists (select 1
            from  sysobjects
            where  id = object_id('Concursante')
            and    type = 'U')
   drop table Concursante
go


if exists (select 1
            from  sysobjects
            where  id = object_id('Votos')
            and    type = 'U')
   drop table Votos
go


/*==============================================================*/
/* Table: Concursante                                           */
/*==============================================================*/
create table Concursante (
     concursante          int                            not null,
     nombre_concursante   varchar(80)                    not null,
     fecha_nacimiento     datetime                       null,
     edad                 int                            null,
     estudios             varchar(60)                    null,
     hobbies              varchar(60)                    null,
     direccion            varchar(30)                    null,
     color_ojos           varchar(30)                    null,
     color_cabello        varchar(30)                    null,
     elemento             varchar(30)                    null,
     foto                 varchar(30)                    null,
     constraint PK_CONCURSANTE primary key (concursante)
)
go


/*==============================================================*/
/* Table: Votos                                                 */
/*==============================================================*/
create table Votos (
     numero               numeric(18)                    identity,
     concursante          int                            not null,
     fecha                datetime                       not null,
     ip                   varchar(15)                    null,
     cookie               varchar(255)                   null,
     email                varchar(80)                    null,
     votante              varchar(80)                    null,
     constraint PK_VOTOS primary key (numero)
)
with
    identity_gap = 100
go


alter table Votos
   add constraint FK_VOTOS_REFERENCE_CONCURSA foreign key (concursante)
      references Concursante (concursante)
go


