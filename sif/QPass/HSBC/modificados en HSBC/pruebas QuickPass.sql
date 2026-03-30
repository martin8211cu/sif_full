/*
select * from QPParametros where Pcodigo = 9998
begin tran 
delete QPControl
delete QPEntrada
delete from QPParametros where Pcodigo = 9998
rollback tran
select * from QPControl
select * from QPEntrada
select * from QPSalida

*/




select * from QPcliente

select * from QPMovCuenta

sp_help QPcuentaBanco

select * from QPventaTags

select * from QPcuentaSaldos where QPctaSaldosid= 55

select len(QPctaBancoNum), QPctaBancoNum from QPcuentaBanco where QPctaBancoid = 34

select min(QPctaBancoid) as CuentaBanco
                    from QPcuentaBanco
                    where Ecodigo   	= 1
                      and QPctaBancoNum	= '01405274056'


dbcc CHECKTABLE ('QPcuentaBanco')

select *
                    from QPcuentaBanco
                    where Ecodigo   	= 1
                      and rtrim(QPctaBancoNum)	= '01405274056'