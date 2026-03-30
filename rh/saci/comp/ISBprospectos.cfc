<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBprospectos">

<cffunction name="asignarAgente" output="false" returntype="void" access="remote">
	<cfargument name="Pquien" type="numeric" required="Yes"  displayname="Prospecto">
	<cfargument name="datasource" type="string" required="No" default="#session.dsn#"  displayname="Conexión">
	
	<cfset LvarHoy = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 0, 0, 0)>
	
	<!--- Plazo en dias para reasignacion de prospectos --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="LvarDiasPlazo">
		<cfinvokeargument name="Pcodigo" value="30">
	</cfinvoke>
	
	<cfset Arangos = ArrayNew(1)>
	
	<cfquery datasource="#Arguments.datasource#" maxrows="3" name="rsrangos">
	 select rangotope,rangodes
	  from ISBrangoValoracion
	 order by rangotope desc
	</cfquery>


	<cfoutput query="rsrangos">
	<cfset ArrayAppend(Arangos, rsrangos.rangodes)>
	</cfoutput>
	
	<cfset ListaRangos =  ArraytoList(Arangos,",")>


	<!--- Borra la tabla de Agentes --->
	<cftry>
		<cfquery datasource="#Arguments.datasource#">
			drop table ##isbAgentes
		</cfquery>
		<cfcatch type="any">
		</cfcatch>
	</cftry>

						
	<!--- Tabla temporal de Agentes --->
	<cfquery datasource="#Arguments.datasource#">
		create table ##isbAgentes (
			id numeric(10) identity,
			AGid int not null,
			Nota varchar(20) not null)
	</cfquery>
				
	<cfquery datasource="#Arguments.datasource#" name="rsAgentesDisp">
		select a.AGid
		from ISBagente a
			inner join ISBagenteCobertura b
				on  b.AGid = a.AGid
				and b.Habilitado = 1
			inner join ISBprospectos c
				on c.LCid = b.LCid
					and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#"> 
		where a.Habilitado = 1
			and a.AAprospecta=1
			<!---and a.AGid not in (
						Select ap.AGid
						from ISBagentePrevio ap
						where ap.Pquien = c.Pquien
					)		--->
		order by a.AGid
	</cfquery>	
	
	<cfset msg = ""> <!--- Sin Errores ---> 
		
	<!--- Si existen Agentes que cubran la zona del prospecto --->	
	<cfif isdefined('rsAgentesDisp') and rsAgentesDisp.RecordCount gt 0>	
			
		<!--- Obtiene la calificación para cada Agente --->
		<cfoutput query="rsAgentesDisp"  group="AGid">
			<cfset puntos = GetPorcentajeCalificacion(AGid,20)>	
			<cfset Nota = GetCalificacion(AGid,puntos)>	
			
			<cfif ListFind(ListaRangos,Nota)> 		
				<cfquery datasource="#Arguments.datasource#" name="rsnotas">
					insert ##isbAgentes (AGid,Nota)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#AGid#" null="#Len(AGid) Is 0#"> ,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Nota#" null="#Len(Nota) Is 0#">)
				</cfquery>		
			</cfif>
		</cfoutput>
		
		<!--- Cantidad de agentes, con las mejores calificaciones (Excelente, Bueno, Regular) --->
		<cfquery datasource="#Arguments.datasource#" name="rselegibles">
			select count(*) as cantidad from ##isbAgentes
			where Nota in  (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" separator="," value="#ArrayToList(Arangos)#">)
		</cfquery>		
				
		
		<!--- Seleccionar un Agentes aleatoriamente, de los mejores calificados --->
		<cfif isdefined('rselegibles') and rselegibles.cantidad gt 0>
			<cfset elegido =  Int(Rand() * #rselegibles.cantidad#)+1>				
		<cfelse>
			<cfset msg = " (No existen Agentes Calificados con calificación (#ListaRangos#) - #DateFormat(Now(),'dd/MM/YYYYY HH:mm:ss')#)">
		</cfif>
				
		<!--- Selecciona el código de agente (AGid) del elegido --->
		<cfif isdefined('elegido')>
		<cfquery datasource="#Arguments.datasource#" name="rselegido">
			select AGid from ##isbAgentes
			where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#elegido#">
		</cfquery>
		</cfif>
	<cfelse>
		<cfset msg = " (No existen Agentes que cubran la Zona del Prospecto - #DateFormat(Now(),'dd/MM/YYYYY HH:mm:ss')#)">
	</cfif>	

		<cfif msg eq "">
		<!--- SI existen agentes disponibles en la misma localidad del prospecto. Se procede a la asignacion --->
			<cfset msg = " (Prospecto Asignado - #DateFormat(Now(),'dd/MM/YYYYY HH:mm:ss')#)">
	
			<cfquery datasource="#Arguments.datasource#">
				update ISBprospectos set 
					AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rselegido.AGid#" null="#Len(rselegido.AGid) Is 0#">	
					, Pasignacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
					, Pprospectacion = 'A'
					, Pobservacion = Pobservacion + <cfqueryparam cfsqltype="cf_sql_varchar" value="#msg#" null="#Len(msg) Is 0#">
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">	
			</cfquery>				
		<cfelse>
	
			<cfquery datasource="#Arguments.datasource#">
				update ISBprospectos set 
					AGid = null
					, Pasignacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
					, Pprospectacion = 'D'
					, Pobservacion = Pobservacion + <cfqueryparam cfsqltype="cf_sql_varchar" value="#msg#" null="#Len(msg) Is 0#">
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">	
			</cfquery>		
		</cfif>
</cffunction>

<!--- Se analiza si al agente se le vencio el plazo en dias para atender al prospecto, si fuera asi se asigna un nuevo agente --->
<cffunction name="analizarAgente" output="false" returntype="void" access="remote">
	<cfargument name="Pquien" type="numeric" required="Yes"  displayname="Prospecto">
	<cfargument name="datasource" type="string"  required="No" default="#session.dsn#" displayname="Conexión">
	
	<cfset LvarHoy = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 0, 0, 0)>

	<!--- Plazo en dias Periodo de Calificación --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="LvarDiasPlazo">
		<cfinvokeargument name="Pcodigo" value="30">
	</cfinvoke>
	
	<cfif Len(Trim(LvarDiasPlazo))>
		<!--- Verificacion de si al agente se le vencio el plazo en dias para atender al prospecto --->
		<cfquery datasource="#Arguments.datasource#" name="rsDiasAsig">
			select AGid
			from ISBprospectos
			where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
			and Pprospectacion = 'A'
			and Pasignacion < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', LvarDiasPlazo * -1, LvarHoy)#">
		</cfquery>
		
		<cfif isdefined('rsDiasAsig') and rsDiasAsig.recordCount GT 0>
			<cfquery datasource="#Arguments.datasource#" name="rsExisteAgente">
				select 1
				from ISBagentePrevio
				where Pquien =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
				and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDiasAsig.AGid#">
			</cfquery>
			<cfif isdefined('rsExisteAgente') and rsExisteAgente.recordCount EQ 0>
				<!--- El agente asignado al prospecto no lo ha atendido --->
				<cfquery datasource="#Arguments.datasource#">
					insert ISBagentePrevio (AGid, Pquien, APfecha)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDiasAsig.AGid#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">					
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
					)
				</cfquery>				
			<cfelse>
				<!--- Se modifica la fecha del registro del agente --->
				<cfquery datasource="#Arguments.datasource#">
					update ISBagentePrevio set 
						APfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarHoy#">
					where Pquien =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
					and AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDiasAsig.AGid#">
				</cfquery>							
			</cfif>
			
			<!--- Insertar valoracion negativa para el agente --->
			<cfinvoke component="saci.comp.ISBagente" method="altaValoraciones" >
				<cfinvokeargument name="AGid" value="#rsDiasAsig.AGid#">			
				<cfinvokeargument name="tipo" value="-1">
				<cfinvokeargument name="observacion" value="No atendió al prospecto después de #LvarDiasPlazo# días">
			</cfinvoke>	
			
			<!--- Inicializar a null el campo del AGid del agente para el prospecto --->
			<cfquery datasource="#Arguments.datasource#">
				update ISBprospectos set 
				      AGid = null
					, Pprospectacion = 'S'
					, Pasignacion = null
				where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
			</cfquery>
			
			<!--- Asignar de nuevo el agente para el prospecto --->
			<cfset asignarAgente(Arguments.Pquien, Arguments.datasource)>
		</cfif>
	<cfelse>
	
		<cflog text="Error, no se ha definido en los parámetros globales el plazo en dias para reasignacion de prospectos" type="error" date="yes" time="yes">
		
	</cfif>
</cffunction>

<cffunction name="revisaAgente" output="true" returntype="numeric" access="remote">
	<cfargument name="Pquien" type="numeric" required="Yes"  displayname="Prospecto">
	<cfargument name="datasource" type="string" required="No" default="#session.dsn#"  displayname="Conexión">
	<cfset retorno = 0>
	
	<cfquery datasource="#Arguments.datasource#" name="rsProsp">
		select LCid, AGid
		from ISBprospectos
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
	</cfquery>
	
	<cfif isdefined('rsProsp') and rsProsp.recordCount EQ 1>
		<cfif Len(Trim(rsProsp.AGid)) EQ 0>
			<!--- Asignar agente al prospecto --->
			<cfset asignarAgente(Arguments.Pquien, Arguments.datasource)>
		<cfelse>
			<!--- Analizar agente del prospecto --->
			<cfset analizarAgente(Arguments.Pquien, Arguments.datasource)>
		</cfif>
	</cfif>
	
	<cfreturn retorno>
</cffunction>

<cffunction name="GetPorcentajeCalificacion" output="true" returntype="numeric" access="remote">
	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
	<cfargument name="plazo" type="numeric" required="No" default="20"  displayname="Indica el plazo de Calificación">
	<cfargument name="datasource" type="string" required="No" default="#session.dsn#"  displayname="Conexión">
	
	<cfset porcentaje = 100>
	
	<!--- Plazo en dias para reasignacion de prospectos --->
	<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="LvarDiasPlazo">
		<cfinvokeargument name="Pcodigo" value="#Arguments.plazo#">
	</cfinvoke>
	
	<cfset LvarHoy = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 0, 0, 0)>
	
	<!--- Suma el Puntaje de Valoraciones Negativas --->
	<cfquery datasource="#Arguments.datasource#" name="rsnegativas">	
	  Select isnull(sum(ANpuntaje),0) as negativas
		from ISBagenteValoracion
	 	where AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">
		and ANfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', LvarDiasPlazo * -1, LvarHoy)#">
		and ANvaloracion = -1 
	</cfquery>
	
	<!--- Suma el Puntaje de Valoraciones Positivas --->
	<cfquery datasource="#Arguments.datasource#" name="rspositivas">	
	  Select isnull(sum(ANpuntaje),0) as positivas
		from ISBagenteValoracion
	 	where AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">
		and ANfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', LvarDiasPlazo * -1, LvarHoy)#">
		and ANvaloracion = 1 
	</cfquery>
	
	<!--- Número de Contratos Vendidos en el Período --->
	<cfquery datasource="#Arguments.datasource#" name="rscontratos">
	Select count(*) as contratos from ISBproducto pro
	Where pro.Vid in (Select ven.Vid from ISBagente ag
                  inner join ISBvendedor ven
                   on ag.AGid = ven.AGid
                   and ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">)
	And CNapertura >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', LvarDiasPlazo * -1, LvarHoy)#">
	</cfquery>
	
	<!---(1-(PuntosNegativos-PuntosPositivos)/Contratos)*100--->
	<cfif rscontratos.contratos eq 0>
		<cfset rscontratos.contratos = 1>	
	</cfif>

	<cfset porcentaje = (1-(#rsnegativas.negativas#-#rspositivas.positivas#)/#rscontratos.contratos#)*100>	

	<cfif porcentaje gt 100>
		<cfset porcentaje = 100>	
	<cfelseif porcentaje lt 0 >
		<cfset porcentaje = 0>	
	</cfif>
	
	<cfreturn Ceiling(porcentaje)>
</cffunction>

<cffunction name="GetCalificacion" output="true" returntype="string" access="remote">
	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
	<cfargument name="porcentaje" type="numeric" required="Yes"  displayname="Porcentaje Asignado">
	<cfargument name="datasource" type="string" required="No" default="#session.dsn#"  displayname="Conexión">

	<cfset calificacion = "No existen rangos de calificación, revisar el parámetro 'Rangos para Calificación de Agentes Autorizados'">

	<cfquery datasource="#Arguments.datasource#" name="rsvalor">
	select max(rangotope) as tope from ISBrangoValoracion
	Where rangotope <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.porcentaje#">
	</cfquery>

	<cfquery datasource="#Arguments.datasource#" name="rscalificacion">
	select rangodes from ISBrangoValoracion
	Where rangotope = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsvalor.tope#">
	</cfquery>

	<cfif isdefined('rscalificacion') and rscalificacion.RecordCount gt 0>
		<cfreturn rscalificacion.rangodes>
	<cfelse>
		<cfreturn calificacion>
	</cfif>

</cffunction>

<cffunction name="proc_prospectacion" output="true" returntype="numeric" access="remote">
	<cfargument name="Ecodigo" type="numeric" required="No" default="#session.Ecodigo#"  displayname="Empresa">
	<cfargument name="datasource" type="string" required="No" default="#session.DSN#"  displayname="Conexión">

	<cfset retorno = 0>

	<cfquery name="listaProspectos" datasource="#Arguments.datasource#">
		select a.Pquien
		from ISBprospectos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		and a.Pprospectacion not in ('D', 'F', 'C')
	</cfquery>
	
	<cfloop query="listaProspectos">
		<cfset revisaAgente(listaProspectos.Pquien, Arguments.datasource)>
	</cfloop>

	<cfreturn retorno>

</cffunction>


<cffunction name="Cambio_Estado" output="false" returntype="void" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Prospecto">
  <cfargument name="Pprospectacion" type="string" required="Yes" displayname="Prospectación">
  <cfargument name="ts_rversion" type="string" required="No" displayname="ts_rversion">
  <cfargument name="datasource" type="string" required="No" default="#session.DSN#" displayname="Conexión">
  
	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#Arguments.datasource#"
						table="ISBprospectos"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="Pquien"
						type1="numeric"
						value1="#Arguments.Pquien#">
	</cfif>
				
	<cfquery datasource="#Arguments.datasource#">
		update ISBprospectos
		set Pprospectacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pprospectacion#">
		, Pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
	</cfquery>

</cffunction>


<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Prospecto">
  <cfargument name="Ppersoneria" type="string" required="No" default="" displayname="Personería">
  <cfargument name="Pid" type="string" required="No" default="" displayname="Identificación">
  <cfargument name="Pnombre" type="string" required="No" default="" displayname="Nombre">
  <cfargument name="Papellido" type="string" required="No" default="" displayname="Apellido">
  <cfargument name="Papellido2" type="string" required="No" default="" displayname="Apellido materno">
  <cfargument name="PrazonSocial" type="string" required="No" default="" displayname="Razón Social">
  <cfargument name="Ppais" type="string" required="No" default="" displayname="País de Origen">
  <cfargument name="Pobservacion" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="Pprospectacion" type="string" required="No" default="" displayname="Prospectación">
  <cfargument name="CPid" type="numeric" required="No"  displayname="Codigo Postal">
  <cfargument name="Papdo" type="string" required="No" default="" displayname="Apdo Postal">
  <cfargument name="LCid" type="numeric" required="Yes"  displayname="Localidad">
  <cfargument name="AGid" type="string" required="No"  displayname="Agente">
  <cfargument name="Pdireccion" type="string" required="No" default="" displayname="Dirección">
  <cfargument name="Pbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="Ptelefono1" type="string" required="Yes"  displayname="Teléfono">
  <cfargument name="Ptelefono2" type="string" required="No" default="" displayname="Teléfono 2">
  <cfargument name="Pfax" type="string" required="No" default="" displayname="Fax">
  <cfargument name="Pemail" type="string" required="No" default="" displayname="e-mail">
  <cfargument name="Pfecha" type="date" required="Yes"  displayname="Fecha">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">
  <cfargument name="Pasignacion" type="string" required="No"  displayname="Fecha de asignación">
  <cfargument name="datasource" type="string" required="No" default="#session.DSN#" displayname="Conexión">
  
<cf_dbtimestamp datasource="#Arguments.datasource#"
				table="ISBprospectos"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="Pquien"
				type1="numeric"
				value1="#Arguments.Pquien#">
				
	<cfquery datasource="#Arguments.datasource#">
		update ISBprospectos
		set Ppersoneria = <cfif isdefined("Arguments.Ppersoneria") and Len(Trim(Arguments.Ppersoneria))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppersoneria#"><cfelse>null</cfif>
		, Pid = <cfif isdefined("Arguments.Pid") and Len(Trim(Arguments.Pid))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pid#"><cfelse>null</cfif>
		, Pnombre = <cfif isdefined("Arguments.Pnombre") and Len(Trim(Arguments.Pnombre))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pnombre#"><cfelse>null</cfif>
		
		, Papellido = <cfif isdefined("Arguments.Papellido") and Len(Trim(Arguments.Papellido))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido#"><cfelse>null</cfif>
		, Papellido2 = <cfif isdefined("Arguments.Papellido2") and Len(Trim(Arguments.Papellido2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido2#"><cfelse>null</cfif>
		, PrazonSocial = <cfif isdefined("Arguments.PrazonSocial") and Len(Trim(Arguments.PrazonSocial))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PrazonSocial#"><cfelse>null</cfif>
		, Ppais = <cfif isdefined("Arguments.Ppais") and Len(Trim(Arguments.Ppais))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppais#"><cfelse>null</cfif>
		
		, Pobservacion = <cfif isdefined("Arguments.Pobservacion") and Len(Trim(Arguments.Pobservacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pobservacion#"><cfelse>null</cfif>
		, Pprospectacion = <cfif isdefined("Arguments.Pprospectacion") and Len(Trim(Arguments.Pprospectacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pprospectacion#"><cfelse>null</cfif>
		, CPid = <cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>
		, Papdo = <cfif isdefined("Arguments.Papdo") and Len(Trim(Arguments.Papdo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papdo#"><cfelse>null</cfif>
		
		, LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
		, AGid = <cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>
		, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, Pdireccion = <cfif isdefined("Arguments.Pdireccion") and Len(Trim(Arguments.Pdireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdireccion#"><cfelse>null</cfif>
		
		, Pbarrio = <cfif isdefined("Arguments.Pbarrio") and Len(Trim(Arguments.Pbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pbarrio#"><cfelse>null</cfif>
		, Ptelefono1 = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono1#" null="#Len(Arguments.Ptelefono1) Is 0#">
		, Ptelefono2 = <cfif isdefined("Arguments.Ptelefono2") and Len(Trim(Arguments.Ptelefono2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono2#"><cfelse>null</cfif>
		, Pfax = <cfif isdefined("Arguments.Pfax") and Len(Trim(Arguments.Pfax))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pfax#"><cfelse>null</cfif>
		
		, Pemail = <cfif isdefined("Arguments.Pemail") and Len(Trim(Arguments.Pemail))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pemail#"><cfelse>null</cfif>
		, Pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pfecha#" null="#Len(Arguments.Pfecha) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		, Pasignacion = <cfif isdefined("Arguments.Pasignacion") and Len(Trim(Arguments.Pasignacion))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pasignacion#"><cfelse>null</cfif>
		
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Pquien" type="numeric" required="Yes"  displayname="Prospecto">
  <cfargument name="datasource" type="string" required="No" default="#session.DSN#" displayname="Conexión">

	<cfquery datasource="#Arguments.datasource#">
		delete ISBprospectos
		where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Ppersoneria" type="string" required="No" default="" displayname="Personería">
  <cfargument name="Pid" type="string" required="No" default="" displayname="Identificación">
  <cfargument name="Pnombre" type="string" required="No" default="" displayname="Nombre">
  <cfargument name="Papellido" type="string" required="No" default="" displayname="Apellido">
  <cfargument name="Papellido2" type="string" required="No" default="" displayname="Apellido materno">
  <cfargument name="PrazonSocial" type="string" required="No" default="" displayname="Razón Social">
  <cfargument name="Ppais" type="string" required="No" default="" displayname="País de Origen">
  <cfargument name="Pobservacion" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="Pprospectacion" type="string" required="No" default="" displayname="Prospectación">
  <cfargument name="CPid" type="numeric" required="No"  displayname="Codigo Postal">
  <cfargument name="Papdo" type="string" required="No" default="" displayname="Apdo Postal">
  <cfargument name="LCid" type="numeric" required="Yes"  displayname="Localidad">
  <cfargument name="AGid" type="string" required="No"  displayname="Agente">
  <cfargument name="Pdireccion" type="string" required="No" default="" displayname="Dirección">
  <cfargument name="Pbarrio" type="string" required="No" default="" displayname="Barrio">
  <cfargument name="Ptelefono1" type="string" required="Yes"  displayname="Teléfono">
  <cfargument name="Ptelefono2" type="string" required="No" default="" displayname="Teléfono 2">
  <cfargument name="Pfax" type="string" required="No" default="" displayname="Fax">
  <cfargument name="Pemail" type="string" required="No" default="" displayname="e-mail">
  <cfargument name="Pfecha" type="date" required="Yes"  displayname="Fecha">
  <cfargument name="Pasignacion" type="string" required="No"  displayname="Fecha de asignación">
  <cfargument name="datasource" type="string" required="No" default="#session.DSN#" displayname="Conexión">

	<cfquery datasource="#Arguments.datasource#" name="rsAlta">
		insert into ISBprospectos (
			Ppersoneria,
			Pid,
			Pnombre,
			
			Papellido,
			Papellido2,
			PrazonSocial,
			Ppais,
			
			Pobservacion,
			Pprospectacion,
			CPid,
			Papdo,
			
			LCid,
			AGid,
			Ecodigo,
			Pdireccion,
			
			Pbarrio,
			Ptelefono1,
			Ptelefono2,
			Pfax,
			
			Pemail,
			Pfecha,
			BMUsucodigo,
			
			Pasignacion)
		values (
			<cfif isdefined("Arguments.Ppersoneria") and Len(Trim(Arguments.Ppersoneria))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppersoneria#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pid") and Len(Trim(Arguments.Pid))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pnombre") and Len(Trim(Arguments.Pnombre))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pnombre#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Papellido") and Len(Trim(Arguments.Papellido))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Papellido2") and Len(Trim(Arguments.Papellido2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papellido2#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.PrazonSocial") and Len(Trim(Arguments.PrazonSocial))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PrazonSocial#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Ppais") and Len(Trim(Arguments.Ppais))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ppais#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pobservacion") and Len(Trim(Arguments.Pobservacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pobservacion#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pprospectacion") and Len(Trim(Arguments.Pprospectacion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pprospectacion#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.CPid") and Len(Trim(Arguments.CPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Papdo") and Len(Trim(Arguments.Papdo))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Papdo#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">,
			<cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfif isdefined("Arguments.Pdireccion") and Len(Trim(Arguments.Pdireccion))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pdireccion#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pbarrio") and Len(Trim(Arguments.Pbarrio))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pbarrio#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono1#" null="#Len(Arguments.Ptelefono1) Is 0#">,
			<cfif isdefined("Arguments.Ptelefono2") and Len(Trim(Arguments.Ptelefono2))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ptelefono2#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.Pfax") and Len(Trim(Arguments.Pfax))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pfax#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.Pemail") and Len(Trim(Arguments.Pemail))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Pemail#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pfecha#" null="#Len(Arguments.Pfecha) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			
			<cfif isdefined("Arguments.Pasignacion") and Len(Trim(Arguments.Pasignacion))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Pasignacion#"><cfelse>null</cfif>)
		<cf_dbidentity1 datasource="#Arguments.datasource#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Arguments.datasource#" name="rsAlta" verificar_transaccion="false">
	
	<cfif isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
		<cfreturn rsAlta.identity>
	<cfelse>
		<cfset retorna = -1>
		<cfreturn retorna>
	</cfif>
</cffunction>

</cfcomponent>

