<cfquery name="rsSec" datasource="#Session.DSN#">
	if exists (select * from PeriodoMatricula pm, MatriculaAlumnoCurso pmc
				where pm.Ecodigo = #session.Ecodigo#
				  and pmc.PMcodigo = pm.PMcodigo
				  and pmc.Apersona = <cfqueryparam value="#form.codApersona#" cfsqltype="cf_sql_numeric">
				  and pmc.PMCtipo = 'M'
				  and pmc.PMCpagado = 0
				  and pmc.PMCmodificado = 0
				)
	BEGIN
		delete from FacturaEduDetalle
		 where exists (select 1 from FacturaEdu
						 where Ecodigo = #session.Ecodigo#
						   and Apersona = <cfqueryparam value="#form.codApersona#" cfsqltype="cf_sql_numeric">
						   and FACtipo = 0
						   and FACestado = 0
						   and FACcodigo = FacturaEduDetalle.FACcodigo
						)
		delete from FacturaEdu
	     where Ecodigo = #session.Ecodigo#
		   and Apersona = <cfqueryparam value="#form.codApersona#" cfsqltype="cf_sql_numeric">
		   and FACtipo = 0
		   and FACestado = 0
		DECLARE @FACcodigo numeric
		INSERT INTO FacturaEdu
			   ( Ecodigo
			   , Apersona
			   , FACfecha
			   , FACnombre
			   , FACtipo
			   , FACestado
			   , FACmonedaISO
			   , FACtipoCambio
			   , FACmonto
			   , FACimpuesto
			   , FACdescuento
			   , FACsaldo
			   , FACobservaciones
			   )
		VALUES ( <cfqueryparam value='#session.Ecodigo#' cfsqlType='cf_sql_integer'>
			   , <cfqueryparam value='#form.codApersona#' cfsqlType='cf_sql_numeric'>
			   , getdate()
			   , <cfqueryparam value='#form.FACnombre#' cfsqlType='cf_sql_varchar'>
			   , 0
			   , 0
			   , 'CRC'
			   , 1.00
			   , 0.00 <!--- Total --->
			   , 0.00 <!--- Impuesto --->
			   , 0.00 <!--- Descuento --->
			   , 0.00 <!--- Saldo --->
			   , null
			   )
		select @FACcodigo = @@identity

		INSERT INTO FacturaEduDetalle
			   ( FACcodigo
			   , FADsecuencia
			   , TTcodigo
			   , FADdescripcion
			   , FADcantidad
			   , FADunitario
			   , FADmonto
			   , FADdescuento
			   , FADexento
			   )
		VALUES ( @FACcodigo
			   , 1
			   , 1	<!--- TTcodigo --->
			   , 'Matricula Periodo 2004/01'
			   , 1
			   , 100.00 <!--- unitario --->
			   , 100.00 <!--- total --->
			   , 0.00   <!--- descuento --->
			   , 1      <!--- exento --->
			   )
	END
</cfquery>


<cflocation url="facturas.cfm?codApersona=#form.codApersona#">