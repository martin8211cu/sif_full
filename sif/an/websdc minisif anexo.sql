drop table Anexo, Anexoim, AnexoEm, AnexoCel, AnexoCelD
go
drop proc AN_TraeAnexo 
go
create table Anexo (
	AnexoId numeric(18,0) identity,
	AnexoDes varchar(100),
	AnexoFec datetime null,
	AnexoUsu varchar(30) null,
	primary key (AnexoId)
)

go

create table Anexoim (
	AnexoId numeric(18,0),
	AnexoDef text,
	primary key(AnexoId)
)
go

create table AnexoEm (
	Ecodigo int,
	AnexoId numeric(18, 0),
	primary key(AnexoId, Ecodigo)
)
go

create index AnexoEm01 on AnexoEm (Ecodigo)
go

create table AnexoCel (
	AnexoCelId numeric(18,0) identity,
	AnexoId    numeric(18,0),
	AnexoRan   char(20),
	AnexoCon   int default = 1,
	AnexoRel   int default = 1,
	AnexoMes   int default = 0,
	AnexoPer   int default = 0,
	Ocodigo    int null,
	AnexoNeg   int null,
	primary key (AnexoCelId))
go

create index AnexoCel01 on AnexoCel (AnexoId)
go

/* Documentación de AnexoCel */
/* 
	AnexoRan:   Nombre del Rango para colocarlo en la hoja de Excel
	AnexoCon:   Concepto del Rango para el calculo

	    1. Nombre de la empresa (del parametro)
	    2. Nombre de la Oficina (del parametro si Ocodigo es nulo, nombre de Oficina si Ocodigo != nulo)

	   10. Numero del mes seleccionado de la celda
	   11. Nombre del mes seleccionado de la celda
	   12. Numero del año seleccionado de la celda
	   13. Numero del mes / Numero del año seleccionado de la celda

	   20. Saldo Final del mes de las cuentas seleccionadas
	   21. Saldo Inicial del mes de las cuentas seleccionadas
	   22. Debitos del mes de las cuentas seleccionadas
	   23. Creditos del mes de las cuentas seleccionadas
	   24. Movimiento neto del mes de las cuentas seleccionadas


	   30. Debitos del periodo de las cuentas seleccionadas
	   31. Creditos del periodo de las cuentas seleccionadas
	   32. Movimiento neto del periodo de las cuentas seleccionadas


	AnexoRel:  Identifica comportamiento del calculo del mes / año para procesar la celda
	    0. El calculo del mes es absoluto de acuerdo al parametro. El año es relativo
	    1. El calculo del año y mes son relativos a los parametros solicitados por el usuario

	Ejemplo.  Si el usuario selecciona el reporte:

		Año:  2002
		Mes:  2 

	   El proceso debera evaluar lo siguiente:

		Si el parametro es relativo (=1)

			MesCalculo = (Mes - AnexoMes)
			AñoCalculo = Año

			Si MesCalculo < 1
				MesCalculo = 12 + (Mes - AnexoMes) % 12 
				AñoCalculo = Año - 1 - ((AnexoMes - Mes) / 12)
				

		Si el parametro es absoluto (=0)

			MesCalculo = AnexoMes de AnexoCel
			AñoCalculo = (Año - AnexoPer de AnexoCel)


	AnexoMes:  Mes para procesar la celda
	AnexoPer:  Año para procesar la celda
	Ocodigo:   Codigo de la oficina para el calculo.  Si es nulo se utiliza el parametro

	AnexoNeg:  Presentar el resultado del calculo multiplicado por -1

*/

create table AnexoCelD (
	AnexoCelId numeric(18,0),
	AnexoCelLin int,
	AnexoCelFmt varchar(100),
	AnexoCelMov char(1),
	primary key (AnexoCelId, AnexoCelLin))
go

 
insert Anexo (AnexoDes, AnexoFec, AnexoUsu) values ('Balance General', '20021025', 'MEsquivel')
go

insert AnexoEm (Ecodigo, AnexoId) select 1, AnexoId from Anexo
go

insert AnexoCel (AnexoId, AnexoRan, AnexoMes, Ocodigo)
select AnexoId, 'Rango1', 0, null
from Anexo
go

insert AnexoCel (AnexoId, AnexoRan, AnexoMes, Ocodigo)
select AnexoId, 'Rango2', 0, null
from Anexo
go

insert AnexoCel (AnexoId, AnexoRan, AnexoMes, Ocodigo)
select AnexoId, 'Rango3', 0, null
from Anexo
go


insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 1, '0013-__-_1', 'N'
from AnexoCel
where AnexoRan = "Rango1"

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 2, '0013-__-_2', 'N'
from AnexoCel
where AnexoRan = "Rango1"

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 3, '0013-__-_3', 'N'
from AnexoCel
where AnexoRan = "Rango1"

go

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 1, '0012-__-__', 'N'
from AnexoCel
where AnexoRan = "Rango2"

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 2, '0041-__-__', 'N'
from AnexoCel
where AnexoRan = "Rango2"

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 3, '0053-__', 'N'
from AnexoCel
where AnexoRan = "Rango2"
go

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 1, '0011-01' 'N'
from AnexoCel
where AnexoRan = "Rango3"

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 2, '0011-02', 'N'
from AnexoCel
where AnexoRan = "Rango3"
go

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 3, '0011-03-__', 'N'
from AnexoCel
where AnexoRan = "Rango3"
go

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 4, '0011-04', 'N'
from AnexoCel
where AnexoRan = "Rango3"
go

insert AnexoCelD (AnexoCelId, AnexoCelLin, AnexoCelFmt, AnexoCelMov)
select AnexoCelId, 5, '0011-05', 'N'
from AnexoCel
where AnexoRan = "Rango3"
go



create proc AN_TraeAnexo 
	@AnexoId numeric(18,0),
	@Ecodigo int,
	@Periodo int,
	@Mes int,
	@Ocodigo int = null,
	@Mcodigo numeric(18, 0) = null

as

/* Calculos del anexo */
/* AnexoCon determina el query:

	a. Obtener el ID de la celda
	b. Calcular el periodo y mes 

		PeriodoCalculado 
		MesCalculado

	c. Procesar el query

	    1. 
		Select Edescripcion from Empresas where Ecodigo = {parametro de Empresa}
	    2. 
		select Odescripcion from Oficinas where Ecodigo = {parametro de Empresa} and Ocodigo = {isnull(parametro de oficina de celda, parametro del reporte)}

	   10. Numero del mes calculado

	   11. Nombre del mes calculado

	   12. Numero del año calculado

	   13. Numero del mes / Numero del año calculado

	   20. Saldo Final del mes de las cuentas seleccionadas
		select AnexoRan, 
			sum(isnull((
			select sum(SLinicial + DLdebitos - CLcreditos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo = @PeriodoCalculado
			  and s.Smes = @MesCalculado
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan



	   21. Saldo Inicial del mes de las cuentas seleccionadas

		select AnexoRan, 
			sum(isnull((
			select sum(SLinicial)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo = @PeriodoCalculado
			  and s.Smes = @MesCalculado
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan


	   22. Debitos del mes de las cuentas seleccionadas
		select AnexoRan, 
			sum(isnull((
			select sum(DLdebitos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo = @PeriodoCalculado
			  and s.Smes = @MesCalculado
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan


	   23. Creditos del mes de las cuentas seleccionadas
		select AnexoRan, 
			sum(isnull((
			select sum(CLcreditos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo = @PeriodoCalculado
			  and s.Smes = @MesCalculado
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan

	   24. Movimiento neto del mes de las cuentas seleccionadas
		select AnexoRan, 
			sum(isnull((
			select sum(DLdebitos - CLcreditos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo = @PeriodoCalculado
			  and s.Smes = @MesCalculado
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan



	   Para los calculos 30, 31 y 32 se requiere el siguiente calculo de periodos

		a. Calcular el mes de inicio del periodo, de acuerdo con PeriodoCalculado y MesCalculado
		b. Calcular el mes de final  del periodo, de acuerdo con PeriodoCalculado y MesCalculado
		c. Calcular el Periodo de inicio, de acuerdo con PeriodoCalculado y MesCalculado
		d. Calcular el Periodo de final,  de acuerdo con PeriodoCalculado y MesCalculado

			select @MesInicial = {primer mes segun parametros de conta}

			if @MesCalculado < @MesInicial
				select @PeriodoInicial = @PeriodoCalculado - 1, @PeridoFinal = @PeriodoCalculado
			else
				select @PeriodoInicial = @PeriodoCalculado, @PeriodoFinal = @PeriodoCalculado + 1

			if {primer mes segun parametros de conta} != 1
				select @MesFinal = {primer mes segun parametros de conta} - 1
			else
				select @MesFinal = 12



	   30. Debitos del periodo de las cuentas seleccionadas

		e. 
		select AnexoRan, 
			sum(isnull((
			select sum(DLdebitos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo > @PeriodoInicial
			  and s.Speriodo <= @PeriodoFinal
			  and (s.Speriodo * 100 + s.Smes) between (@PeriodoInicial * 100 + @MesInicial) and (@PeriodoFinal * 100 + @MesFinal)
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan


	   31. Creditos del periodo de las cuentas seleccionadas

		e. 
		select AnexoRan, 
			sum(isnull((
			select sum(CLcreditos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo > @PeriodoInicial
			  and s.Speriodo <= @PeriodoFinal
			  and (s.Speriodo * 100 + s.Smes) between (@PeriodoInicial * 100 + @MesInicial) and (@PeriodoFinal * 100 + @MesFinal)
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan


	   32. Movimiento neto del periodo de las cuentas seleccionadas

		e. 
		select AnexoRan, 
			sum(isnull((
			select sum(DLdebitos - CLcreditos)
			from CContables c, SaldosContables s
			where c.Ecodigo = @Ecodigo
			  and c.Cformato like d.AnexoCelFmt
			  and s.Ccuenta = c.Ccuenta
			  and s.Speriodo > @PeriodoInicial
			  and s.Speriodo <= @PeriodoFinal
			  and (s.Speriodo * 100 + s.Smes) between (@PeriodoInicial * 100 + @MesInicial) and (@PeriodoFinal * 100 + @MesFinal)
			  and s.Ecodigo = @Ecodigo
			  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
			  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
			), 0.00)) as Saldo
		from AnexoCel a, AnexoCelD d
		where a.AnexoCelId = @AnexoCelId
		  and d.AnexoCelId = a.AnexoCelId
		group by AnexoRan




	Si se desea presentar en negativo, el Saldo resultante debe multiplicarse por -1

*/

/* Esto es como estaba al principio */

select AnexoRan, 
	sum(isnull((
	select sum(SLinicial + DLdebitos - CLcreditos)
	from CContables c, SaldosContables s
	where c.Ecodigo = @Ecodigo
	  and c.Cformato like d.AnexoCelFmt
	  and s.Ccuenta = c.Ccuenta
	  and s.Speriodo = @PeriodoCalculado
	  and s.Smes = @MesCalculado
	  and s.Ecodigo = @Ecodigo
	  and (@Ocodigo is null or s.Ocodigo = @Ocodigo)
	  and (@Mcodigo is null or s.Mcodigo = @Mcodigo)
	), 0.00)) as Saldo
from AnexoCel a, AnexoCelD d
where a.AnexoCel = @AnexoCel
and d.AnexoCelId = a.AnexoCelId
group by AnexoRan


go
sp_procxmode AN_TraeAnexo, anymode
go


