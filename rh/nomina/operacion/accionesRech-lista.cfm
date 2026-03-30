<!---
	Cuando el módulo es utilizado por el Administrator (Cuando Session.Params.ModoDespliegue EQ 1)
	Este módulo es incluido desde dos pantallas: desde el expediente del empleado y como pantalla independiente para registro de acciones de personal
	Para saber desde donde se esta llamando se pregunta por una variable que se llama tabChoice la cual únicamente está presenta cuando se incluye el módulo desde esas pantallas
	Cuando se está trabajando desde el expediente hay que asegurarse de reenviar los parámetros de o, sel y DEid los cuales son necesarios para esa pantalla
--->
<cfset navegacion = "">

<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset a = ListToArray(Form.Usuario, '|')>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif not (isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1")>
	<cfset Form.Usuario = Session.Usucodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & "-1">
</cfif>


<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset a = ListToArray(Form.Usuario, '|')>
	<cfset filtro = " and a.Usucodigo = " & a[1]>
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">
	<cfset filtro = "">
<cfelse>
	<cfset filtro = " and a.Usucodigo = " & Session.Usucodigo>
	<cfset Form.Usuario = Session.Usucodigo & "|" & Session.Ulocalizacion>
</cfif>

<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfset filtro = filtro & " and a.DEid = " & Form.DEid >
</cfif>


<cfif isdefined("Form.DLfvigencia") and Len(Trim(Form.DLfvigencia)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DLfvigencia=" & Form.DLfvigencia>
</cfif>
<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DLffin=" & Form.DLffin>
</cfif>

<cfif Session.Params.ModoDespliegue EQ 0>
	<cfset filtro = filtro & " and b.RHTautogestion = 1" >
</cfif>

<cfset additionalCols = "">
<cfif isdefined("Form.o") and isdefined("Form.sel") and isdefined("Form.DEid")>
	<cfset additionalCols = "'" & Form.o & "' as o, '" & Form.sel & "' as sel, '" & Form.DEid & "' as DEid, ">
</cfif>

<!--- Usuarios que han insertado acciones --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct Usucodigo
	from RHAcciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!---convert(varchar, u.Usucodigo)+'|#Session.Ulocalizacion#' as Codigo,--->
<cf_dbfunction name="to_char" args=" u.Usucodigo" returnvariable="Usucodigo">
<cf_dbfunction name="concat" args="#Usucodigo#%'|'%'#session.Ulocalizacion#'" returnvariable="codigo" delimiters="%">
<cf_dbfunction name="concat" args="d.Papellido1,' ',d.Papellido2,' ',d.Pnombre" returnvariable="Nombre" >
<cfquery name="rsUsuarios" datasource="asp">
	select #preservesinglequotes(codigo)# as Codigo,
		   #preservesinglequotes(Nombre)# as Nombre
	from Usuario u, DatosPersonales d
	<cfif rsUsuariosRegistro.recordCount GT 0>
		where u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsUsuariosRegistro.Usucodigo, ',')#">)
	<cfelse>
		where u.Usucodigo = 0
	</cfif>
	and u.datos_personales = d.datos_personales
</cfquery> 

<cfif not isdefined("tabChoice")>
<form name="filtroAcciones" method="post" action="">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
  <tr> 
    <td class="fileLabel"><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_FechaVence">Fecha Vence</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_Usuario">Usuario</cf_translate></td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cfif isdefined("Form.DLfvigencia")>
            <cfset fecha = Form.DLfvigencia>
            <cfelse>
            <cfset fecha = "">
        </cfif>
		<cf_sifcalendario form="filtroAcciones" value="#fecha#" name="DLfvigencia" tabindex="1">	
	</td>
    <td>
		<cfif isdefined("Form.DLfvigencia")>
            <cfset fecha = Form.DLffin>
            <cfelse>
            <cfset fecha = "">
        </cfif>
		<cf_sifcalendario form="filtroAcciones" value="#fecha#" name="DLffin" tabindex="1">	
	</td>
    <td>
	  <select name="Usuario" tabindex="1">
		  <option value="-1" <cfif Form.Usuario EQ "-1">selected</cfif>>(<cf_translate key="LB_Todos">Todos</cf_translate>)</option>
		<cfoutput query="rsUsuarios">
		  <option value="#rsUsuarios.Codigo#" <cfif Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
		</cfoutput>
	  </select>
	</td>
      <td align="center">
	  	<!--- Variable para traduccion --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>
		<input name="btnBuscar" type="submit" id="btnBuscar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
      </td>
  </tr>
</table>
</form>
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaBorrarEstasAccionesRechazadas"
	Default="Desea borrar estas acciones rechazadas"
	returnvariable="MSG_DeseaBorrarEstasAccionesRechazadas"/>

<script language="JavaScript" type="text/javascript">
	function funcReintentar() {
		if (document.listaAcciones.chk) {
			if (document.listaAcciones.chk.value) {
				return (document.listaAcciones.chk.checked);
			} else {
				for (var i=0; i<document.listaAcciones.chk.length; i++) {
					if (document.listaAcciones.chk[i].checked) return true;
				}
			}
		}
		return false;
	}
	
	function funcBorrar() {
		if (document.listaAcciones.chk) {
			if(confirm('<cfoutput>#MSG_DeseaBorrarEstasAccionesRechazadas#</cfoutput> ?')){		
				if (document.listaAcciones.chk.value) {
					return (document.listaAcciones.chk.checked);
				} else {
					for (var i=0; i<document.listaAcciones.chk.length; i++) {
						if (document.listaAcciones.chk[i].checked)
							return true;
					}
				}
			}				
		}
		return false;
	}
	
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<!--- Variables para traduccion --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Empleado"
			Default="Empleado"
			returnvariable="LB_Empleado"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TipoDeAccion"
			Default="Tipo de Acción"
			returnvariable="LB_TipoDeAccion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaRige"
			Default="Fecha Rige"
			returnvariable="LB_FechaRige"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaVence"
			Default="Fecha Vence"
			returnvariable="LB_FechaVence"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Reintentar"
			Default="Reintentar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Reintentar"/>	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Borrar"
			Default="Borrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Borrar"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_INDEFINIDO"
			Default="INDEFINIDO"
			returnvariable="LB_INDEFINIDO"/>

		<!---'<b>' + c.DEidentificacion + '</b> ' + c.DEapellido1 + ' ' + c.DEapellido2 + ', '  + c.DEnombre as NombreEmp,
			'<b>' + rtrim(b.RHTcodigo) + '</b> - ' + b.RHTdesc as TipoAccion,--->

		<cf_dbfunction name="concat" args="c.DEidentificacion,' ',c.DEapellido1,' ',c.DEapellido2,' ',c.DEnombre" returnvariable="NombreEmp" >
		<cf_dbfunction name="concat" args="b.RHTcodigo,'-',b.RHTdesc" returnvariable="TipoAccion" >
		<cf_dbfunction name="to_char" args="DLfvigencia" returnvariable="FechaRige" >
		<cf_dbfunction name="to_char" args="DLffin" returnvariable="DLffin" >
		
		
		<cfquery name="lista" datasource="#session.DSN#">
			select 	#additionalCols# 
					a.RHAlinea, 
					#preservesinglequotes(NombreEmp)# as NombreEmp,
					#preservesinglequotes(TipoAccion)# as TipoAccion,
					#FechaRige# as FechaRige,
					case when DLffin is not null then #DLffin# else '#LB_INDEFINIDO#' end as FechaVence ,
					'#form.Usuario#' as Usuario
			from RHAcciones a, RHTipoAccion b, DatosEmpleado c , WfxProcess d
			where a.Ecodigo = #Session.Ecodigo# 
				and a.RHTid = b.RHTid 
				and a.DEid = c.DEid 
				and a.RHAidtramite is not null
				and a.Usucodigo > 0
				and a.RHAidtramite = d.ProcessInstanceId
				and State='COMPLETE'
				
				<cfif isdefined("Form.DLfvigencia") and Len(Trim(Form.DLfvigencia)) NEQ 0>
					and a.DLfvigencia = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(Form.DLfvigencia)#">
				</cfif>
				<cfif isdefined("Form.DLffin") and Len(Trim(Form.DLffin)) NEQ 0>
					and a.DLffin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(Form.DLffin)#">
				</cfif>

				#filtro# 

				order by c.DEidentificacion, DLfvigencia, DLffin
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
            <cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="NombreEmp, TipoAccion, FechaRige, FechaVence"/>
			<cfinvokeargument name="etiquetas" value="#LB_Empleado#, #LB_TipoDeAccion#, #LB_FechaRige#, #LB_FechaVence#"/>
			<cfinvokeargument name="formatos" value=""/>	
			<cfinvokeargument name="align" value="left, left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Reintentar,Borrar"/>
			<cfinvokeargument name="irA" value="/cfmx/rh/nomina/operacion/accionesRech-SQL.cfm"/>
			<cfinvokeargument name="keys" value="RHAlinea"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="formName" value="listaAcciones"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
	</td>
  </tr>
</table>
