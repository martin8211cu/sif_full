

<cfif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
	<cfquery name="rsEncab" datasource="#session.tramites.dsn#">
		select codigo_sucursal,nombre_sucursal
		from TPSucursal
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
			and id_sucursal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
	</cfquery>
	<cfquery name="rsLista" datasource="#session.tramites.dsn#">							
		Select 
			'#form.id_sucursal#' as id_sucursal
			,id_tiposerv
			,id_inst
			,codigo_tiposerv
			,nombre_tiposerv
		from TPTipoServicio
		where id_tiposerv not in (
					Select 
						tas.id_tiposerv 
					from TPAgendaServicio tas
						inner join TPTipoServicio  ts
							on ts.id_tiposerv =tas.id_tiposerv 
								and ts.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
						inner join TPSucursal s
							on s.id_sucursal = tas.id_sucursal
								and s.id_inst = ts.id_inst								
								and tas.id_sucursal=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
				)
			and id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	</cfquery>	
<cfelseif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
	<cfquery name="rsEncab" datasource="#session.tramites.dsn#">
		select codigo_tiposerv,nombre_tiposerv
		from TPTipoServicio
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
			and id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tiposerv#">
	</cfquery> 
	<cfquery name="rsLista" datasource="#session.tramites.dsn#">
		Select 
			'#form.id_tiposerv#' as id_tiposerv
			, id_inst
			,id_sucursal
			,codigo_sucursal
			,nombre_sucursal
		from TPSucursal
		where id_sucursal not in (
					Select 
						tas.id_sucursal
					from TPAgendaServicio tas
						inner join TPSucursal s
							on s.id_sucursal=tas.id_sucursal
								and s.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
				)
			and id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	</cfquery>	
</cfif>
	
<form name="formAgendaServ" method="post" action="agendaServ/agendaServ-sql.cfm" onSubmit="javascript: return funcGenerar();">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" align="center"  bgcolor="#CACACA" style="border:1px solid black">
			<font size="3" color="#003399">
				<strong>
					<cfoutput>
						<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
							Tipo de servicio (#rsEncab.codigo_tiposerv#)-#rsEncab.nombre_tiposerv#
						<cfelseif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
							Sucursal (#rsEncab.codigo_sucursal#)-#rsEncab.nombre_sucursal#						
						</cfif>			
					</cfoutput>					
				</strong>
			</font>
		</td>
	  </tr>
	  <tr>
		<td width="62%" align="center" bgcolor="#E2E2E2"><strong>
		
			Datos para crear Nueva Agenda
		
		</strong></td>
	  <td width="38%" align="center" bgcolor="#E2E2E2">
			<strong>		
				<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
					Sucursales
				<cfelseif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
					Tipos de Servicio
				</cfif>	  
		</strong>  </td>
	  </tr>
	  <tr>
		<td valign="top">
          <cfinclude template="agendaServ-form.cfm">
		</td>
		<td valign="top">
			<div style="overflow:auto; height:350; width:220; margin:0;">
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
							<cfinvokeargument name="desplegar" value="codigo_sucursal,nombre_sucursal"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Sucursal"/>
						<cfelseif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
							<cfinvokeargument name="desplegar" value="codigo_tiposerv,nombre_tiposerv"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Servicio"/>
						</cfif>
						<cfinvokeargument name="formatos" value="S,S"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="S"/>			
						<cfinvokeargument name="irA" value="listaServSuc.cfm"/>
						<cfinvokeargument name="showLink" value="false"/>			
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
							<cfinvokeargument name="keys" value="id_sucursal"/>
						<cfelseif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
							<cfinvokeargument name="keys" value="id_tiposerv"/>
						</cfif>			
				</cfinvoke>	
			</div>			
		</td>
	  </tr>
<!--- 	  <tr>
	    <td colspan="2" align="center">
			<cfif isdefined('modo') and modo NEQ 'ALTA'>
				<cf_botones modo="#modo#"> 		
			<cfelse>
				<cf_botones modo="#modo#" include="Generar" includevalues="Generar" exclude="ALTA"> 		
			</cfif>	 		
		</td>
	  </tr> --->
	</table>
</form>

<script language="javascript" type="text/javascript">
	function algunoMarcado(){
		var aplica = false;
		var form = document.formAgendaServ;
		if (form.chk) {
			if (form.chk.value) {
				aplica = form.chk.checked;
			} else {
				for (var i=0; i<form.chk.length; i++) {
					if (form.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (aplica);
		} else {
			<cfif isdefined('form.tab') and form.tab EQ '2'>
				alert('Debe seleccionar al menos un tipo de servicio antes de realizar esta acción!.');			
			<cfelseif isdefined('form.tab') and form.tab EQ '5'>
				alert('Debe seleccionar al menos una sucursal antes de realizar esta acción!.');			
			<cfelse>
				alert('Debe seleccionar al menos una línea de la lista de checks antes de realizar esta acción!.');	
			</cfif>		

			return false;
		}
	}
</script>
