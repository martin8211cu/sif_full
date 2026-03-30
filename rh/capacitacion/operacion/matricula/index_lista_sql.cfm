<cfsetting requesttimeout="36000">

<cfset LISTACHK = ListToArray(FORM.CHK)>
<cftry>
		<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
		  <cfif isdefined("FORM.ABRIR")>
				<cfquery name="ABC_Evaluacion_Masivo" datasource="#Session.DSN#">
					update RHRelacionCap
					set RHRCestado = 2
					where Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
					and RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					and RHRCestado < 2
				</cfquery>	
		  <cfelseif isdefined("FORM.CERRAR")>
				<cfquery name="ABC_Evaluacion_Masivo" datasource="#Session.DSN#">
<!---
					<!--- Modificacion de Totales Globales por Item --->
					update RHNotasEvalDes 
					set 
					RHNEDnotajefe = (
						select convert(numeric(8,4), avg(a.RHDEporcentaje))
						from RHDRelacionCap a, RHEvaluadoresDes b
						where a.RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and b.RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and a.RHRCid = RHNotasEvalDes.RHRCid
						  and a.DEid = RHNotasEvalDes.DEid
						  and (a.RHICid = RHNotasEvalDes.RHICid or (a.RHICid is null and RHNotasEvalDes.RHICid is null))
						  and (a.RHIHid = RHNotasEvalDes.RHIHid or (a.RHIHid is null and RHNotasEvalDes.RHIHid is null))
						  and b.RHRCid = a.RHRCid
						  and b.DEid = a.DEid
						  and b.DEideval = a.DEideval
						  and b.RHEDtipo = 'J'
						  and a.RHDEporcentaje is not null
						), 
					RHNEDnotaauto = (
						select convert(numeric(8,4), avg(a.RHDEporcentaje))
						from RHDRelacionCap a, RHEvaluadoresDes b
						where a.RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and b.RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and a.RHRCid = RHNotasEvalDes.RHRCid
						  and a.DEid = RHNotasEvalDes.DEid
						  and (a.RHICid = RHNotasEvalDes.RHICid or (a.RHICid is null and RHNotasEvalDes.RHICid is null))
						  and (a.RHIHid = RHNotasEvalDes.RHIHid or (a.RHIHid is null and RHNotasEvalDes.RHIHid is null))
						  and b.RHRCid = a.RHRCid
						  and b.DEid = a.DEid
						  and b.DEideval = a.DEideval
						  and b.RHEDtipo = 'A'
						  and a.RHDEporcentaje is not null
						), 
					RHNEDpromotros = (
						select convert(numeric(8,4), avg(a.RHDEporcentaje))
						from RHDRelacionCap a, RHEvaluadoresDes b
						where a.RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and b.RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
						  and a.RHRCid = RHNotasEvalDes.RHRCid
						  and a.DEid = RHNotasEvalDes.DEid
						  and (a.RHICid = RHNotasEvalDes.RHICid or (a.RHICid is null and RHNotasEvalDes.RHICid is null))
						  and (a.RHIHid = RHNotasEvalDes.RHIHid or (a.RHIHid is null and RHNotasEvalDes.RHIHid is null))
						  and b.RHRCid = a.RHRCid
						  and b.DEid = a.DEid
						  and b.DEideval = a.DEideval
						  and b.RHEDtipo not in ('A', 'J')
						  and a.RHDEporcentaje is not null
						) 
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					
					update RHNotasEvalDes set RHNEDpromedio = convert(numeric(8,4), (RHNEDnotajefe + RHNEDnotaauto + RHNEDpromotros) / 3)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is not null
					  and RHNEDnotaauto is not null
					  and RHNEDpromotros is not null
					
					update RHNotasEvalDes set RHNEDpromedio = convert(numeric(8,4), (RHNEDnotajefe + RHNEDnotaauto ) / 2)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is not null
					  and RHNEDnotaauto is not null
					  and RHNEDpromotros is null
					
					update RHNotasEvalDes set RHNEDpromedio = convert(numeric(8,4), (RHNEDnotajefe + RHNEDpromotros ) / 2)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is not null
					  and RHNEDnotaauto is null
					  and RHNEDpromotros is not null
					
					update RHNotasEvalDes set RHNEDpromedio = convert(numeric(8,4), (RHNEDnotaauto + RHNEDpromotros ) / 2)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is null
					  and RHNEDnotaauto is not null
					  and RHNEDpromotros is not null
					
					update RHNotasEvalDes set RHNEDpromedio = RHNEDnotajefe
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is not null
					  and RHNEDnotaauto is null
					  and RHNEDpromotros is null
					
					update RHNotasEvalDes set RHNEDpromedio = RHNEDnotaauto
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is null
					  and RHNEDnotaauto is not null
					  and RHNEDpromotros is null
					
					update RHNotasEvalDes set RHNEDpromedio = RHNEDpromotros
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHNEDnotajefe is null
					  and RHNEDnotaauto is null
					  and RHNEDpromotros is not null
	
					<!--- Fin - Modificacion de Totales Globales por Item --->
			
					<!--- Modificacion de Totales Globales --->
					update RHDRelacionCap
					set RHLEnotajefe = ( select convert(numeric(7,4),avg(RHNEDnotajefe)) 
										from RHNotasEvalDes a
										where a.RHRCid=<cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
										  and a.RHRCid=RHDRelacionCap.RHRCid
										  and a.DEid=RHDRelacionCap.DEid
										  and a.RHNEDnotajefe is not null ),
					
						RHLEnotaauto =  ( select convert(numeric(7,4),avg(RHNEDnotaauto)) 
										from RHNotasEvalDes a
										where a.RHRCid=<cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
										  and a.RHRCid=RHDRelacionCap.RHRCid
										  and a.DEid=RHDRelacionCap.DEid
										  and a.RHNEDnotaauto is not null ), 
					
					
						RHLEpromotros = ( select convert(numeric(7,4),avg(RHNEDpromotros) )  
										 from RHNotasEvalDes a
										 where a.RHRCid=<cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
										   and a.RHRCid=RHDRelacionCap.RHRCid
										   and a.DEid=RHDRelacionCap.DEid
										   and a.RHNEDpromotros is not null )
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					and Ecodigo=<cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
					
					update RHDRelacionCap set promglobal = convert(numeric(8,4), (RHLEnotajefe + RHLEnotaauto + RHLEpromotros) / 3)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is not null
					  and RHLEnotaauto is not null
					  and RHLEpromotros is not null
					
					update RHDRelacionCap set promglobal = convert(numeric(8,4), (RHLEnotajefe + RHLEnotaauto ) / 2)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is not null
					  and RHLEnotaauto is not null
					  and RHLEpromotros is null
					
					update RHDRelacionCap set promglobal = convert(numeric(8,4), (RHLEnotajefe + RHLEpromotros ) / 2)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is not null
					  and RHLEnotaauto is null
					  and RHLEpromotros is not null
				
					update RHDRelacionCap set promglobal = convert(numeric(8,4), (RHLEnotaauto + RHLEpromotros ) / 2)
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is null
					  and RHLEnotaauto is not null
					  and RHLEpromotros is not null
					
					update RHDRelacionCap set promglobal = RHLEnotajefe
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is not null
					  and RHLEnotaauto is null
					  and RHLEpromotros is null
					
					update RHDRelacionCap set promglobal = RHLEnotaauto
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is null
					  and RHLEnotaauto is not null
					  and RHLEpromotros is null
					
					update RHDRelacionCap set promglobal = RHLEpromotros
					where RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					  and RHLEnotajefe is null
					  and RHLEnotaauto is null
					  and RHLEpromotros is not null
--->					  

					update RHRelacionCap
					set RHRCestado = 3
					where Ecodigo = <cfqueryparam value="#SESSION.ECODIGO#" cfsqltype="cf_sql_integer">
					and RHRCid = <cfqueryparam value="#LISTACHK[i]#" cfsqltype="cf_sql_numeric">
					and RHRCestado = 2
				</cfquery>
		  </cfif>
		</cfloop>

	<!--- genera una anotacion positiva en el expediente --->
	<cfif isdefined("FORM.CERRAR")>
		<cfloop from="1" to="#ArrayLen(LISTACHK)#" index="i">
			<cfquery name="data" datasource="#session.DSN#">
				select RHEEtipoeval, TEcodigo, RHRCdescripcion
				from RHRelacionCap
				where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHRCid = <cfqueryparam value="#listaChk[i]#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset descripcion = 'Obtención de calificación máxima para Evaluación de Desempeño: ' & data.RHRCdescripcion >
			
			<cfif data.RHEEtipoeval eq 'T'>
				<!--- Trae el valor maximo de la tabla de evaluacion --->
				<cfquery name="data_maximo" datasource="#session.DSN#">
					select isnull(max(TEVmaximo),max(TEVequivalente)) as TEVmaximo
					from TablaEvaluacionValor a, TablaEvaluacion b
					where a.TEcodigo=<cfqueryparam value="#data.TEcodigo#" cfsqltype="cf_sql_numeric">
					  and b.Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and a.TEcodigo=b.TEcodigo
				</cfquery>
				
				<!--- verifica que haya empleados con calficacion maxima --->
				<cfquery name="data_empleados" datasource="#session.DSN#">
					select DEid
					from RHDRelacionCap a, RHRelacionCap b, TablaEvaluacion c, TablaEvaluacionValor d
					where a.RHRCid = <cfqueryparam value="#listaChk[i]#" cfsqltype="cf_sql_numeric">
					and a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and d.TEVmaximo = <cfqueryparam value="#data_maximo.TEVmaximo#" cfsqltype="cf_sql_numeric">
					and a.RHRCid=b.RHRCid
					and b.TEcodigo=c.TEcodigo
					and b.Ecodigo=c.Ecodigo
					and c.TEcodigo=d.TEcodigo
					and a.promglobal between isnull(d.TEVminimo, d.TEVequivalente) and isnull(d.TEVmaximo, d.TEVequivalente)
				</cfquery>
	
			<cfelse>
				<cfquery name="data_empleados" datasource="#session.DSN#">
					select DEid
					from RHDRelacionCap
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHRCid = <cfqueryparam value="#listaChk[i]#" cfsqltype="cf_sql_numeric">
					  and promglobal = 100
				</cfquery>
			</cfif>
			
			<cfif isdefined("data_empleados") and data_empleados.RecordCount gt 0>
				<cfquery name="insert_anotacion" datasource="#session.DSN#">
					<cfloop query="data_empleados">
						insert RHAnotaciones(DEid, RHAfecha, RHAfsistema, RHAdescripcion, Usucodigo, Ulocalizacion, RHAtipo)
						values ( <cfqueryparam value="#data_empleados.DEid#" cfsqltype="cf_sql_numeric">,
								 getDate(),
								 getDate(),
								 <cfqueryparam value="#descripcion#" cfsqltype="cf_sql_varchar">,
								 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
								 '00',
								 1
							   )
					</cfloop>
				</cfquery>
			</cfif>
		</cfloop>	
	</cfif>	

	<cfcatch type="any">
		<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cflocation url="index.cfm">