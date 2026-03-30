<cffunction name="fnExists" output="true">
	<cfargument name="LvarSQL">
	<cfargument name="LvarDatasource" default="#session.DSN#">

	<cfquery name="rsExists" datasource="#LvarDatasource#" >
		select count(1) as cantidad from dual where exists(#preservesinglequotes(LvarSQL)#)
	</cfquery>
	<cfreturn (rsExists.cantidad EQ 1)>
</cffunction>

<cfparam name="session.parametros.UltimaEmpresa" default="">
<cfif session.parametros.UltimaEmpresa EQ session.Ecodigo>
	<cfexit>
</cfif>

<cfset session.parametros.UltimaEmpresa = session.Ecodigo>

<!--- Grupo 10 Nomenclatura--->
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='Creditos'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 10,1, 'Creditos','Nombre de la unidad de medida de la carga académica por curso', 'C', 'Creditos')
	</cfquery>
</cfif>
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='Facultad'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 10,2, 'Facultad','Nombre del Primer Nivel de la Estructura Organizacional', 'C', 'Facultad')
	</cfquery>
</cfif>
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='Escuela'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 10,3, 'Escuela','Nombre del Segundo Nivel de la Estructura Organizacional', 'C', 'Escuela')
	</cfquery>
</cfif>
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='OfertaAca1'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 10,10, 'OfertaAca1','Introducción a la Oferta Académica para el Primer Nivel', 'C', 'Nuestra Universidad le ofrece diferentes Carreras en las siguientes Facultades:')
	</cfquery>
</cfif>
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='OfertaAca2'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 10,11, 'OfertaAca2','Introducción a la Oferta Académica para el Segundo Nivel, Carreras y Planes', 'C', 'Nuestros Planes de Estudios se han diseñado con los mejores estándares de Excelencia Académica:')
	</cfquery>
</cfif>
<!--- Grupo 20: Tipos de Matricula --->
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='MatriculaLinea'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 20,1, 'MatriculaLinea','Permite tipo de matricula en línea, donde el estudiante queda matriculado inmediatamente al registrar su matrícula, y se genera una cuenta por cobrar a pagar en el futuro', 'B', '1')
	</cfquery>
</cfif>
<cfif not fnExists("select * from ParametrosGenerales where Ecodigo = #session.Ecodigo# and PGnombre='MatriculaPago'")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ParametrosGenerales (Ecodigo, PGgrupo, PGsecuencia, PGnombre, PGdescripcion, PGtipo, PGvalor) values 	(#session.Ecodigo#, 20,2, 'MatriculaPago','Permite tipo de matricula en firme hasta el pago, donde el estudiante no queda matriculado inmediatamente al registrar su matrícula, sino que queda en firme hasta realizar el pago', 'B', '1')
	</cfquery>
</cfif>
<cfif not fnExists("select * from Monedas where Ecodigo = #session.Ecodigo#")>
	<cfquery name="rsGetMoneda" datasource="asp">
	  select #session.Ecodigo# as Ecodigo, Mnombre, Msimbolo, Miso4217
	  from Moneda
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into Monedas (Ecodigo, Mnombre, Msimbolo, Miso4217)
	  values( 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGetMoneda.Ecodigo#">,
	  			<cfqueryparam cfsqltype="cf_sql_char"  value="#rsGetMoneda.Mnombre#">,
				<cfqueryparam cfsqltype="cf_sql_char"  value="#rsGetMoneda.Msimbolo#">,
				<cfqueryparam cfsqltype="cf_sql_char"  value="#rsGetMoneda.Miso4217#">
			)
	</cfquery>
</cfif>
<cfif not fnExists("select * from TarifasTipo where Ecodigo = #session.Ecodigo#")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TarifasTipo (Ecodigo, TTnombre, TTtipo)
	  values (#session.Ecodigo#, 'Tarifa de la Matricula por Período',1)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TarifasTipo (Ecodigo, TTnombre, TTtipo)
	  values (#session.Ecodigo#, 'Tarifa de cada Curso por Período',2)
	</cfquery>
</cfif>
<cfif not fnExists("select * from TarifasTipo where Ecodigo = #session.Ecodigo# and TTtipo=3")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TarifasTipo (Ecodigo, TTnombre, TTtipo)
	  values (#session.Ecodigo#, 'Tarifa de Otros Items',3)
	</cfquery>
</cfif>
<cfif not fnExists("select * from GradoAcademico where Ecodigo = #session.Ecodigo#")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into GradoAcademico (Ecodigo, GAnombre, GAorden) values (#session.Ecodigo#, 'Maestría',1)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into GradoAcademico (Ecodigo, GAnombre, GAorden) values (#session.Ecodigo#, 'Licenciatura',2)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into GradoAcademico (Ecodigo, GAnombre, GAorden) values (#session.Ecodigo#, 'Bachillerato',3)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into GradoAcademico (Ecodigo, GAnombre, GAorden) values (#session.Ecodigo#, 'Diplomado',4)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into GradoAcademico (Ecodigo, GAnombre, GAorden) values (#session.Ecodigo#, 'Técnico',5)
	</cfquery>
</cfif>
<cfif not fnExists("select * from TablaEvaluacion where Ecodigo = #session.Ecodigo#")>
	<cftransaction>
	<cfquery name="qryDefaultsRetIdentity" datasource="#session.DSN#">
	  insert into TablaEvaluacion (Ecodigo, TEnombre, TEtipo) 
									values (#session.Ecodigo#, 'Tabla A-B-C-D-E-F','1')
		<cf_dbidentity1 datasource="#Session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="qryDefaultsRetIdentity">
	</cftransaction>
	<cfset PK = qryDefaultsRetIdentity.identity>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVnombre, TEVdescripcion, TEVequivalente, TEVminimo, TEVmaximo)
	  							values (#PK#,      'A'     , 'Excelente', 'Excelente de 91% a 100%', 100, 90.001,  100)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVnombre, TEVdescripcion, TEVequivalente, TEVminimo, TEVmaximo)
	  							values (#PK#,      'B'     , 'Bueno',     'Bueno de 81% a 90%',       90, 80.001,  90)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVnombre, TEVdescripcion, TEVequivalente, TEVminimo, TEVmaximo)
	  							values (#PK#,      'C'     , 'Regular',     'Regular de 71% a 80%',   80, 70.001,  80)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVnombre, TEVdescripcion, TEVequivalente, TEVminimo, TEVmaximo)
	  							values (#PK#,      'D'     , 'Suficiente',  'Suficiente de 61% a 70%',70, 60.001,  70)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVnombre, TEVdescripcion, TEVequivalente, TEVminimo, TEVmaximo)
	  							values (#PK#,      'E'     , 'Malo',     'Malo de 51% a 60%',         60, 50.001,  60)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into TablaEvaluacionValor (TEcodigo, TEVvalor, TEVnombre, TEVdescripcion, TEVequivalente, TEVminimo, TEVmaximo)
	  							values (#PK#,      'F'     , 'Muy Malo', 'Muy Malo de 0% a 50%',      50, 0,       50)
	</cfquery>
</cfif>
<cfif not fnExists("select * from ConceptoEvaluacion where Ecodigo = #session.Ecodigo#")>
	<cftransaction>
 	<cfquery name="qryDefaultsRetIdentity" datasource="#session.DSN#">
		insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Exámenes cortos','',1)
		<cf_dbidentity1 datasource="#Session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="qryDefaultsRetIdentity">
	</cftransaction>
	<cfset CEcodigo = qryDefaultsRetIdentity.identity>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Tareas','',2)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Tareas y Exámenes cortos','',3)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Trabajos de Campo','',4)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Trabajos de Investigación','',5)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Tareas Programadas','',6)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Parciales','',7)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into ConceptoEvaluacion (Ecodigo, CEnombre, CEdescripcion, CEorden) values (#session.Ecodigo#, 'Examen Final','',8)
	</cfquery>	  
	<cftransaction>
	<cfquery name="qryDefaultsRetIdentity" datasource="#session.DSN#">
	  insert into PlanEvaluacion (Ecodigo, PEVnombre) values (#session.Ecodigo#, 'Plan de Evaluación Estándar')
		<cf_dbidentity1 datasource="#Session.DSN#">
	</cfquery>  
	<cf_dbidentity2 datasource="#Session.DSN#" name="qryDefaultsRetIdentity">
	</cftransaction>
	<cfset PK = qryDefaultsRetIdentity.identity>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into PlanEvaluacionConcepto (PEVcodigo, CEcodigo, PECporcentaje, PECorden) values (#PK#, #CEcodigo#+2,20,1)
	</cfquery>	  
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into PlanEvaluacionConcepto (PEVcodigo, CEcodigo, PECporcentaje, PECorden) values (#PK#, #CEcodigo#+4,20,2)
	</cfquery>	  
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into PlanEvaluacionConcepto (PEVcodigo, CEcodigo, PECporcentaje, PECorden) values (#PK#, #CEcodigo#+6,40,3)
	</cfquery>	  
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into PlanEvaluacionConcepto (PEVcodigo, CEcodigo, PECporcentaje, PECorden) values (#PK#, #CEcodigo#+7,20,4)
	</cfquery>
</cfif>
<cfif not fnExists("select * from CicloLectivoTipo where Ecodigo = #session.Ecodigo#")>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into CicloLectivoTipo (Ecodigo, CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones) values (#session.Ecodigo#, 'Mes',         12,  4, 0)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into CicloLectivoTipo (Ecodigo, CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones) values (#session.Ecodigo#, 'Bimestre',     6,  7, 1)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into CicloLectivoTipo (Ecodigo, CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones) values (#session.Ecodigo#, 'Trimestre',    4, 10, 2)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into CicloLectivoTipo (Ecodigo, CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones) values (#session.Ecodigo#, 'Cuatrimestre', 3, 14, 2)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
	  insert into CicloLectivoTipo (Ecodigo, CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones) values (#session.Ecodigo#, 'Semestre',     2, 20, 4)
	</cfquery>
</cfif>
<cfif not fnExists("select * from TablaResultado where Ecodigo = #session.Ecodigo#")>
	<cftransaction>
 	<cfquery name="qryDefaultsRetIdentity" datasource="#session.DSN#">
		insert into TablaResultado (Ecodigo,TRnombre,TRcantidadAmpliacion) 
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				 ,'Aprobación con 70%, Ampliación con 60%',1)
		<cf_dbidentity1 datasource="#Session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="qryDefaultsRetIdentity">
	</cftransaction>
	<cfset PK = qryDefaultsRetIdentity.identity>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into TablaResultadoRango (TRcodigo,TRRtipo,TRRnombre,TRRetiqueta,TRRminimo,TRRmaximo) values(#PK#,'1','Para Ganar el curso','Aprobado',70,100)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into TablaResultadoRango (TRcodigo,TRRtipo,TRRnombre,TRRetiqueta,TRRminimo,TRRmaximo) values(#PK#,'2','Requiere Ampliación','Aplazado',60,69.99)
	</cfquery>
	<cfquery name="qryDefaults" datasource="#session.DSN#">
		insert into TablaResultadoRango (TRcodigo,TRRtipo,TRRnombre,TRRetiqueta,TRRminimo,TRRmaximo) values(#PK#,'3','Para Perder el curso','Reprobado',0,59.99)
	</cfquery>
</cfif>
	
<cfquery name="qryDefaults" datasource="#session.DSN#">
	select * from ParametrosGenerales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfoutput query="qryDefaults">
	<cfset session.parametros[trim(PGnombre)] = PGvalor>
</cfoutput>
