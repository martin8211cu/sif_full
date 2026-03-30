<cfparam name="action" default="Puestos.cfm">

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Eliminar")>
		<cfquery name="RHHabPuestoDelete" datasource="#session.DSN#">
			delete from RHHabilidadesPuesto 
			where RHPcodigo = (select RHPcodigo from RHPuestos
						   where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						   and RHPcodigo ='#form.RHPcodigo#') 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid_2#">
		</cfquery>
		<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
			update RHPuestos 
			set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo = '#form.RHPcodigo#' 
		</cfquery>		
				
	<cfelseif isdefined("form.Agregar")>
		<cfquery name="RHHabPuestoConsulta" datasource="#session.DSN#">
			select 1 
			from RHHabilidadesPuesto a, RHPuestos b   
			where a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo 
			and b.RHPcodigo = '#form.RHPcodigo#'
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and a.RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
		</cfquery>
		<cfif isdefined("RHHabPuestoConsulta") and RHHabPuestoConsulta.RecordCount EQ 0>
		    <cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
				select RHPcodigo from RHPuestos
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				and RHPcodigo = '#form.RHPcodigo#'
		    </cfquery>	
			<cfquery name="RHHabPuestoInsert" datasource="#session.DSN#">
				insert into RHHabilidadesPuesto(RHPcodigo, Ecodigo, RHHid, RHNid, RHHtipo, RHNnotamin, RHHpeso,RHHpesoJefe, ubicacionB, PCid, RHIHid,BMUsucodigo)
				values( <cfqueryparam cfsqltype="cf_sql_char" value="#RHPuestoObtenerCodigo.RHPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHtipo#">,
						<cfif len(trim(form.RHNnotamin)) >
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHNnotamin/100#">
						<cfelse>null</cfif>, 
						<cfif isdefined("form.RHHpeso") and len(trim(form.RHHpeso))>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpeso#">
						<cfelse>1</cfif>,
						<cfif isdefined("form.RHHpesoJefe") and len(trim(form.RHHpesoJefe))>
							<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpesoJefe#">
						<cfelse>1</cfif>,
						<cfif isdefined("form.ubicacionB") and len(trim(form.ubicacionB))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacionB#"><cfelse>null</cfif> 
						,<cfif isdefined("form.PCid") and len(trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif> 
						,<cfif isdefined("form.RHIHid") and len(trim(form.RHIHid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIHid#"><cfelse>null</cfif> 
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
			</cfquery>	
			<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
				update RHPuestos 
				set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and RHPcodigo = '#form.RHPcodigo#' 
			</cfquery>			
			
				
		</cfif>
	
	
	<cfelseif isdefined("form.Modificar")>			
		<cfquery name="RHHAbPuestoUpdate" datasource="#session.DSN#">
			update RHHabilidadesPuesto
			set RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">, 
				RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHNid#">, 
				RHHtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHtipo#">, 
				RHNnotamin = <cfif len(trim(form.RHNnotamin)) >
								<cfqueryparam cfsqltype="cf_sql_float" value="#form.RHNnotamin/100#">
							<cfelse>null</cfif>,
				RHHpeso = <cfif isdefined("form.RHHpeso") and len(trim(form.RHHpeso))>
								<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpeso#">
							<cfelse>1</cfif>,
				RHHpesoJefe = <cfif isdefined("form.RHHpesoJefe") and len(trim(form.RHHpesoJefe))>
								<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHHpesoJefe#">
							<cfelse>1</cfif>,			
				ubicacionB = <cfif isdefined("form.ubicacionB") and len(trim(form.ubicacionB))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ubicacionB#"><cfelse>null</cfif>
				,PCid = <cfif isdefined("form.PCid") and len(trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif>
				,RHIHid = <cfif isdefined("form.RHIHid") and len(trim(form.RHIHid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIHid#"><cfelse>null</cfif>
				,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where RHPcodigo = (select RHPcodigo from RHPuestos
						       where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
						       and RHPcodigo ='#form.RHPcodigo#') 
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid_2#">
		</cfquery>
		<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
			update RHPuestos 
			set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
				 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHPcodigo = '#form.RHPcodigo#' 
		</cfquery>		
	</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="sel"    type="hidden" value="1">
	<input name="o" type="hidden" value="5">
	<input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#">
	<cfif isdefined("form.PageNum")><input name="PageNum" type="hidden" value="#form.PageNum#"></cfif>
	<cfif isdefined("form.Modificar")>
		<input name="RHHid" type="hidden" value="#form.RHHid#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>