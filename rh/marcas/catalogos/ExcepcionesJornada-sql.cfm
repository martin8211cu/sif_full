<cfif not isdefined("form.RHEJlunes")> 	
	<cfset form.RHEJlunes = 0>
<cfelse>
	<cfset form.RHEJlunes = 1>
</cfif>

<cfif not isdefined("form.RHEJmartes")> 	
	<cfset form.RHEJmartes = 0>	
<cfelse>
	<cfset form.RHEJmartes = 1>	
</cfif>

<cfif not isdefined("form.RHEJmiercoles")> 	
	<cfset form.RHEJmiercoles = 0>	
<cfelse>
	<cfset form.RHEJmiercoles = 1>	
</cfif>

<cfif not isdefined("form.RHEJjueves")> 	
	<cfset form.RHEJjueves = 0>	
<cfelse>
	<cfset form.RHEJjueves = 1>	
</cfif>

<cfif not isdefined("form.RHEJviernes")> 	
	<cfset form.RHEJviernes = 0>	
<cfelse>
	<cfset form.RHEJviernes = 1>	
</cfif>

<cfif not isdefined("form.RHEJsabado")> 	
	<cfset form.RHEJsabado = 0>	
<cfelse>
	<cfset form.RHEJsabado = 1>	
</cfif>

<cfif not isdefined("form.RHEJdomingo")> 	
	<cfset form.RHEJdomingo = 0>	
<cfelse>
	<cfset form.RHEJdomingo = 1>	
</cfif>
<!----=================== TRADUCCION ====================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Ya_existe_una_excepcion_que_contempla_los_dias_y_horas_seleccionadas"
	Default="Ya existe una excepci&oacute;n que contempla los d&iacute;as y horas seleccionados."	
	returnvariable="MSG_YaExisteExcepcion"/>	

<cf_throw message="#MSG_YaExisteExcepcion#" errorcode="4005">	 

<cfif isdefined("form.RHJid") and not IsDefined("form.Baja")>
	<cfquery name="rsHS" datasource="#session.DSN#">
		select RHJhorafin 
		from RHJornadas 
		where RHJid = <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset rsHS.RHJhorafin ='2001-1-1 '& trim(toString(TimeFormat(rsHS.RHJhorafin,'h:mtt')))>

</cfif>

<cfif IsDefined("form.Cambio")>
	
	<!---- Cambiar las horas de inicio y fin por la militar para poder compararla con las que estan en la BD's---->
	<cfif isdefined("form.RHEJhorainicio_s") and len(trim(form.RHEJhorainicio_s)) and Form.RHEJhorainicio_s EQ 'PM'><!---Si es pasado meridiano y no son las 12 medianoche---->
		<cfset vn_horainicio = Form.RHEJhorainicio_h + 12>
		 <cfif Form.RHEJhorainicio_h EQ 12 >
			 <cfset vn_horainicio = 12>
		 </cfif>
	<cfelseif  isdefined("form.RHEJhorainicio_s") and len(trim(form.RHEJhorainicio_s)) and Form.RHEJhorainicio_s EQ 'AM'>
		<cfset vn_horainicio = Form.RHEJhorainicio_h>
		<cfif vn_horainicio eq 12 >
			<cfset vn_horainicio = 0 >
		</cfif>
	</cfif>
		
	<cfif isdefined("form.RHEJhorafinal_s") and len(trim(form.RHEJhorafinal_s)) and Form.RHEJhorafinal_s EQ 'PM'>
		<cfset vn_horafinal = Form.RHEJhorafinal_h + 12>
		 <cfif Form.RHEJhorafinal_h EQ 12 >
			 <cfset vn_horafinal = 12>
		 </cfif>
	<cfelseif isdefined("form.RHEJhorafinal_s") and len(trim(form.RHEJhorafinal_s)) and Form.RHEJhorafinal_s EQ 'AM'>
		<cfset vn_horafinal = Form.RHEJhorafinal_h>
		<cfif vn_horafinal eq 12 >
			<cfset vn_horafinal = 0 >
		</cfif>
	</cfif>
	
	<cfset vs_filtrodias = ''>
	<cfif form.RHEJlunes NEQ 0><!--- LUNES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJlunes = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJlunes = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJmartes NEQ 0><!--- MARTES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJmartes = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJmartes = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJmiercoles NEQ 0><!--- MIERCOLES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJmiercoles = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJmiercoles = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJjueves NEQ 0><!--- JUEVES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJjueves = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJjueves = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJviernes NEQ 0><!--- VIERNES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJviernes = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJviernes = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJsabado NEQ 0><!--- SABADO ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJsabado = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJsabado = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJdomingo NEQ 0><!--- DOMINGO ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJdomingo = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJdomingo = 1">
		</cfif>		
	</cfif>
	
	<!---Validar que no exista una excepcion para ese dia de la semana (L,K,M,J,V,S,D) y que las horas seleccionadas no esten ya contempladas en otra excepcion
		para la misma jornada----->
	<cfset hinicio = CreateDateTime(2001, 01, 01, vn_horainicio, Form.RHEJhorainicio_m,0)>
	<cfset hfin = CreateDateTime(2001, 01, 01, vn_horafinal, Form.RHEJhorafinal_m, 0)>

	<cfif datecompare(hinicio, hfin) eq 1>
		<cfset hfin = dateadd('d', 1, hfin)>
	</cfif>
	 
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select count(1) as cantRegistros
		from RHExcepcionesJornada		   
		where RHEJhorainicio < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#hfin#">
			and RHEJhorafinal > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#hinicio#">
			and RHJid = <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
			<cfif isdefined("vs_filtrodias") and len(trim(vs_filtrodias))>
				and (#PreserveSingleQuotes(vs_filtrodias)#)
			</cfif>
			and RHEJid != <cfqueryparam value="#form.RHEJid#" cfsqltype="cf_sql_numeric">						
	</cfquery>	

	<cfif rsVerifica.RecordCount EQ 0 or rsVerifica.cantRegistros EQ 0>
		<cfquery name="update" datasource="#session.DSN#">
			update RHExcepcionesJornada set
				RHJid = <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">,
				CIid  = <cfqueryparam value="#form.CIid#" cfsqltype="cf_sql_numeric">,
				RHEJlunes  = <cfqueryparam value="#form.RHEJlunes#"  cfsqltype="cf_sql_bit">,
				RHEJmartes  = <cfqueryparam value="#form.RHEJmartes#"  cfsqltype="cf_sql_bit">,
				RHEJmiercoles  = <cfqueryparam value="#form.RHEJmiercoles#"  cfsqltype="cf_sql_bit">,
				RHEJjueves = <cfqueryparam value="#form.RHEJjueves#"  cfsqltype="cf_sql_bit">,
				RHEJviernes = <cfqueryparam value="#form.RHEJviernes#"  cfsqltype="cf_sql_bit">,
				RHEJsabado = <cfqueryparam value="#form.RHEJsabado#"  cfsqltype="cf_sql_bit">,
				RHEJdomingo = <cfqueryparam value="#form.RHEJdomingo#"  cfsqltype="cf_sql_bit">,
				RHEJhorainicio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#hinicio#">,
				RHEJhorafinal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#hfin#">
			where RHEJid = <cfqueryparam value="#form.RHEJid#" cfsqltype="cf_sql_numeric">			
		</cfquery>
	<cfelse>			
		<cf_throw message="#MSG_YaExisteExcepcion#" errorcode="4005">	 
	</cfif>	
	
	<cflocation url="ExcepcionesJornada.cfm?RHEJid=#form.RHEJid#">
	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
	   	 delete from RHExcepcionesJornada
	  	 where  RHEJid = <cfqueryparam value="#form.RHEJid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cflocation url="ExcepcionesJornada.cfm">
	
<cfelseif IsDefined("form.Alta")>
	
	<cfif isdefined("form.RHEJhorainicio_s") and len(trim(form.RHEJhorainicio_s)) and Form.RHEJhorainicio_s EQ 'PM'><!---Si es pasado meridiano y no son las 12 medianoche---->
		<cfset vn_horainicio = Form.RHEJhorainicio_h + 12>
		 <cfif Form.RHEJhorainicio_h EQ 12 >
			 <cfset vn_horainicio = 12>
		 </cfif>
	<cfelseif  isdefined("form.RHEJhorainicio_s") and len(trim(form.RHEJhorainicio_s)) and Form.RHEJhorainicio_s EQ 'AM'>
		<cfset vn_horainicio = Form.RHEJhorainicio_h>
		<cfif vn_horainicio eq 12 >
			<cfset vn_horainicio = 0 >
		</cfif>
	</cfif>
		
	<cfif isdefined("form.RHEJhorafinal_s") and len(trim(form.RHEJhorafinal_s)) and Form.RHEJhorafinal_s EQ 'PM'>
		<cfset vn_horafinal = Form.RHEJhorafinal_h + 12>
		 <cfif Form.RHEJhorafinal_h EQ 12 >
			 <cfset vn_horafinal = 12>
		 </cfif>
	<cfelseif isdefined("form.RHEJhorafinal_s") and len(trim(form.RHEJhorafinal_s)) and Form.RHEJhorafinal_s EQ 'AM'>
		<cfset vn_horafinal = Form.RHEJhorafinal_h>
		<cfif vn_horafinal eq 12 >
			<cfset vn_horafinal = 0 >
		</cfif>
	</cfif>
	
	<!---Validar que no exista una excepcion para ese dia de la semana (L,K,M,J,V,S,D) y que las horas seleccionadas no esten ya contempladas en otra excepcion----->
	<cfset vs_filtrodias = ''>
	<cfif form.RHEJlunes NEQ 0><!--- LUNES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJlunes = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJlunes = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJmartes NEQ 0><!--- MARTES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJmartes = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJmartes = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJmiercoles NEQ 0><!--- MIERCOLES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJmiercoles = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJmiercoles = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJjueves NEQ 0><!--- JUEVES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJjueves = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJjueves = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJviernes NEQ 0><!--- VIERNES ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJviernes = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJviernes = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJsabado NEQ 0><!--- SABADO ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJsabado = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJsabado = 1">
		</cfif>		
	</cfif>
	<cfif form.RHEJdomingo NEQ 0><!--- DOMINGO ---->
		<cfif len(trim(vs_filtrodias)) EQ 0>
			<cfset vs_filtrodias = vs_filtrodias & " RHEJdomingo = 1">
		<cfelse>
			<cfset vs_filtrodias = vs_filtrodias & " or RHEJdomingo = 1">
		</cfif>		
	</cfif>
	
	<cfset hinicio = CreateDateTime(2001, 01, 01, vn_horainicio, Form.RHEJhorainicio_m,0)>
	<cfset hfin = CreateDateTime(2001, 01, 01, vn_horafinal, Form.RHEJhorafinal_m, 0)>

	<cfif datecompare(hinicio, hfin) eq 1>
		<cfset hfin = dateadd('d', 1, hfin)>
	</cfif>
	
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select count(1) as cantRegistros
		from RHExcepcionesJornada		   
		where RHEJhorainicio < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#hfin#">
			and RHEJhorafinal > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#hinicio#">
			and RHJid = <cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">
			<cfif isdefined("vs_filtrodias") and len(trim(vs_filtrodias))>
				and (#PreserveSingleQuotes(vs_filtrodias)#)
			</cfif>		
	</cfquery>
	
	<cfif rsVerifica.RecordCount EQ 0 or rsVerifica.cantRegistros EQ 0>
		<cfquery datasource="#session.dsn#">
			insert into RHExcepcionesJornada(RHJid,CIid,RHEJlunes,RHEJmartes,RHEJmiercoles,RHEJjueves,RHEJviernes,RHEJsabado,RHEJdomingo,RHEJhorainicio,RHEJhorafinal,BMUsucodigo,BMfecha)
			values(	<cfqueryparam value="#form.RHJid#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.CIid#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.RHEJlunes#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#form.RHEJmartes#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#form.RHEJmiercoles#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#form.RHEJjueves#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#form.RHEJviernes#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#form.RHEJsabado#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#form.RHEJdomingo#"  cfsqltype="cf_sql_bit">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#hinicio#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#hfin#">, 
					<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">)
		</cfquery>	
	<cfelse>
		<cf_throw message="#MSG_YaExisteExcepcion#" errorcode="4005">	 
	</cfif>
	
	<cflocation url="ExcepcionesJornada.cfm"> 

<cfelse>
	<cflocation url="ExcepcionesJornada.cfm"> 
</cfif>
