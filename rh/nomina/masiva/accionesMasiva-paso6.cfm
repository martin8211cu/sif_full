<!----==================== TRADUCCION ======================------>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"	
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre_Empleado"
	Default="Nombre Empleado"	
	returnvariable="LB_Nombre_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consultar"
	Default="Consultar"	
	returnvariable="LB_Consultar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_se_Encontraron_Registros"
	Default="No se Encontraron Registros"	
	returnvariable="LB_No_se_Encontraron_Registros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Anterior"
	Default="Anterior"
	returnvariable="BTN_Anterior"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar_Acciones"
	Default="Aplicar Acciones"
	returnvariable="BTN_Aplicar_Acciones"/>	


<cfset navegacion = "RHAid=" & Form.RHAid & "&paso=" & Form.paso>

<!--- Consultas --->
<cfquery name="rsAccionesMasiva" datasource="#Session.DSN#">
	select a.RHTAid, a.RHAid, a.RHAcodigo, a.RHAdescripcion, a.Ecodigo, b.Edescripcion, a.RHAfdesde, a.RHAfhasta
	from RHAccionesMasiva a
		inner join Empresas b 
		on a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
</cfquery>


<cfoutput>
	<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
		<tr>
			<td colspan="4">
				<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
					<tr>
						<td width="19%" nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Detalle_Accion">Detalle Accion</cf_translate>:</div></td>
						<td width="81%" nowrap >#rsAccionesMasiva.RHAcodigo# - #rsAccionesMasiva.RHAdescripcion#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Desde">Fecha Desde</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsAccionesMasiva.RHAfdesde,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap class="fileLabel" ><div align="right"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta</cf_translate>:</div></td>
						<td nowrap >#LSDateFormat(rsAccionesMasiva.RHAfhasta,'dd/mm/yyyy')#</td>
					</tr>
				</table>			
			</td>		
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="4">
				<fieldset style="background-color:##CCCCCC; border: 1px solid ##AAAAAA; height: 15;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20" align="center">
						<tr>
							<td class="fileLabel">&nbsp;<cf_translate key="LB_Lista_de_Acciones_Masivas">LISTA DE ACCIONES MASIVAS</cf_translate></td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
		<tr>
			<td colspan="4">
				
				<cfset Filtrar_por = ArrayNew(1)>
				<cfset ArrayAppend(Filtrar_por, "b.DEidentificacion")>
				<cfset ArrayAppend(Filtrar_por, "{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) }")>
				<cfset ArrayAppend(Filtrar_por, "")>

				<cfquery name="rsLista" datasource="#session.DSN#">
					select '#Form.paso#' as paso,
							a.RHAid,
							a.RHAlinea,
							a.DEid, 
							b.DEidentificacion,
							{fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } as Nombre,
							{fn concat({fn concat({fn concat('<img border=''0'' src=''/cfmx/rh/imagenes/iedit.gif'' onClick="javascript:return funcInformacion(', '''')}, <cf_dbfunction name="to_char" args="a.RHAlinea"> )}, ''');">') } as Informe
					from RHAcciones a
								inner join DatosEmpleado b
									on a.DEid = b.DEid
									and a.Ecodigo = b.Ecodigo
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
							and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							<cfif isdefined("form.FILTRO_DEIDENTIFICACION") and len(trim(form.FILTRO_DEIDENTIFICACION))>
								and upper(b.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FILTRO_DEIDENTIFICACION)#%">
							</cfif>
							<cfif isdefined("form.FILTRO_NOMBRE") and len(trim(form.FILTRO_NOMBRE))>
								and upper({fn concat({fn concat({fn concat({ fn concat(rtrim(b.DEnombre), ' ') },rtrim(b.DEapellido1))}, ' ')},rtrim(b.DEapellido2)) } ) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.FILTRO_NOMBRE)#%">
							</cfif>
					order by b.DEidentificacion
				</cfquery>
				<cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion, Nombre, Informe "/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Nombre_Empleado#, #LB_Consultar#"/>						
						<cfinvokeargument name="filtrar_por_array" value="#Filtrar_por#"/>
						<cfinvokeargument name="maxrows" value="10"/>
						<cfinvokeargument name="formatos" value="S,S,G"/>
						<cfinvokeargument name="align" value="left,left,center"/>
						<cfinvokeargument name="ajustar" value="S,S,S"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>										
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="emptylistmsg" value=" ---  #LB_No_se_Encontraron_Registros# ---"/>
						<cfinvokeargument name="ira" value="#CurrentPage#"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>						
						<cfinvokeargument name="keys" value="RHAlinea"/>
						<cfinvokeargument name="showLink" value="false"/>
				</cfinvoke>
			</td>
		</tr>
		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>
	</table>
	<form name="form1" method="post" style="margin: 0;" action="accionesMasiva-sql.cfm">
		<cfinclude template="accionesMasiva-hiddens.cfm">	
		<table width="90%" border="0" cellspacing="0" cellpadding="1" align="center">
			<tr>
				<td colspan="4">
                	<cfif rsLista.RecordCount GT 0>
					<cf_botones names="btnRegresar,btnAplicar" values="<< #BTN_Anterior#,#BTN_Aplicar_Acciones#">
                    <cfelse>
                    <cf_botones names="btnRegresar" values="<< #BTN_Anterior#">
                    </cfif>
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	<!--- Variables --->
	var popUpWinSN = 0;
	var _paso  = document.form1.paso.value;
	var _RHAid = document.form1.RHAid.value;
	
	function funcInformacion(id) {
		var width = 800;
		var height = 600;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var nuevo = window.open('accionesMasiva-ConsultarMasiva.cfm?RHAlinea='+id+'&RHAid='+_RHAid, 'Consulta', 'menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
		document.lista.nosubmit = true;
		return false;	
	}

	function funcFiltrar(){
		document.lista.PASO.value = _paso;
		document.lista.RHAID.value = _RHAid;
		return true;
	}
	
	function funcbtnRegresar(){
		document.form1.paso.value = "5";
	}	
</script>
