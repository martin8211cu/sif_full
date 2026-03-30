
IF not exists(Select * from CSATTipoRel where CSATcodigo = '07')
              BEGIN
                  insert into CSATTipoRel  (CSATcodigo, CSATdescripcion, CSATdefault)
                  values ('07', 'CFDI por aplicación de anticipo',null)
              END;
