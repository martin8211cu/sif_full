<cf_templateheader title="Distribuciones">
	<cf_web_portlet_start titulo="Distribuciones">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfset navegacion ="">
		<cfif isdefined("form.IDgd") and form.IDgd neq "">
			<cfset navegacion = 'IDGD=#form.IDgd#'>
		</cfif>
		<cfif isdefined("url.IDgd") and url.IDgd neq "" and not isdefined("form.IDgd")>
			<cfset form.IDgd = url.IDgd>
			<cfset navegacion = 'IDGD=#url.IDgd#'>
		</cfif>
		<cfquery name="rsGrupo" datasource="#session.DSN#">
			select DCdescripcion
			from DCGDistribucion
			where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
		</cfquery>
		
		<cfset G_Dist = rsGrupo.DCdescripcion>
		
		<!---Tipos--->
		<cfquery name="rsTipos" datasource="#session.DSN#">
			select  -1 as value, 'Todos' as description from dual
			union all
			select 1 as value, '1 - Por Movimientos de la Cuenta' as description from dual
			union all
			select 2 as value, '2 - Por Movs.de la cuenta X porcentaje ' as description from dual
			union all
			select 3 as value, '3 - Equitativa' as description from dual
			union all
			select 4 as value, '4 - Por Pesos digitados' as description from dual
			union all
			select 5 as value, '5 - Por Conductores' as description from dual			
			order by 1
		</cfquery>
        

		<cfquery name="rsOrigenes" datasource="#session.DSN#">
			select  '-1' as value, 'Todos' as description from dual
			union all
			select B.Oorigen as value, <cf_dbfunction name='concat' args="(B.Oorigen + '-' + B.Odescripcion)" delimiters='+'> as descripcion
			from DCGDistribucion A, Origenes B
			where A.Oorigen = B.Oorigen
			  and A.IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
			order by 1
		</cfquery>		
	
		<table cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td class="tituloListas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>Distribuciones dentro del Grupo:</strong> <cfoutput>#G_Dist#</cfoutput>
			</td>
		</tr>
		<tr><td class="tituloListas">&nbsp;</td></tr>
		<tr>
			<td>
				
                <cf_dbfunction name='concat' args="(C.Oorigen + '-' + C.Odescripcion)" delimiters='+' returnvariable='LvarOrg'>
				<cfinvoke component="sif.Componentes.pListas" method="pLista"			
					tabla="DCGDistribucion A, DCDistribucion B, Origenes C"
					columnas="A.IDgd,B.IDdistribucion, A.DCdescripcion, B.Descripcion, #LvarOrg# as Org, 
																case when B.Tipo = 1 then 'Por Movs de la cuenta'
																	 when B.Tipo = 2 then 'Por Movs de la cuenta X porcentaje'
																	 when B.Tipo = 3 then 'Equitativa'
																	 when B.Tipo = 4 then 'Pesos digitados'
																	 when B.Tipo = 5 then 'Por Conductores'
																	 end as Tipo"
					filtro="A.IDgd = B.IDgd 
							  and A.Ecodigo = B.Ecodigo 
							  and A.Oorigen  = C.Oorigen 
							  and A.Ecodigo=#session.Ecodigo#
							  and A.IDgd = #form.IDgd#
							Order By IDdistribucion"
					desplegar="Descripcion,Tipo"
					etiquetas="Tipo,Descripcion"
					formatos="S,S"
					align="left,left"
					irA="Distribuciones.cfm?IDgd=#form.IDgd#"
					keys="IDdistribucion"
					showEmptyListMsg="true"
					form_method="post"
					mostrar_filtro="true"
					filtrar_automatico="true"
					filtrar_por="B.Tipo,B.Descripcion"
					rsOrg = "#rsOrigenes#"
					rsTipo="#rsTipos#"
					maxrows="15"
					navegacion="#navegacion#"
				/>
		
			</td>
		</tr>
		</table>		
		
		<cfquery name="rsVerificaDist" datasource="#session.dsn#">
		Select count(1) as total
		from DCGDistribucion A, DCDistribucion B, Origenes C
		where A.IDgd 	= B.IDgd 
		  and A.Ecodigo = B.Ecodigo 
		  and A.Oorigen = C.Oorigen 
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and A.IDgd    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
		  and B.Tipo    = 5
		</cfquery>
		
		<br>
		<form name="formBotones">
		<cfif rsVerificaDist.total eq 0>
			<cf_botones values="Nuevo" names="Nuevo" include="Regresar">
		<cfelse>	
			<!--- Las transacciones tipo 5 solo permiten agregar una distribución --->
			<cf_botones exclude="Alta,Limpiar" include="Regresar">
		</cfif>
		</form>
		
		<script type="text/javascript" defer>
		<!--
			function mostrar(IDdistribucion){
				location.href='Distribuciones.cfm?IDdistribucion=' +  escape (IDdistribucion);
			}
			function funcNuevo(){
				location.href='Distribuciones.cfm?IDgd=<cfoutput>#form.IDgd#</cfoutput>';
				return false;
			}
			function funcFiltrar()
			{
				document.lista.IDGD.value="<cfoutput>#form.IDgd#</cfoutput>";
				return true;
			}
			function funcRegresar()
			{
				document.location = 'formgrupos.cfm?IDgd=<cfoutput>#form.IDgd#</cfoutput>';
				return false;
			}
		//-->
		</script>

	<cf_web_portlet_end>
<cf_templatefooter>
