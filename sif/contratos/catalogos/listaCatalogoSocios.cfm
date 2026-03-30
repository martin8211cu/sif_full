<!--- **
	Modificado: Andres Lara
	*******--->
<cfinclude template="CSociosModalidad.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SIFAdministracionDelSistema" Default="SIF - Administraci&oacute;n del Sistema" XmlFile="/sif/generales.xml" returnvariable="LB_SIFAdministracionDelSistema"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Numero" Default= "N&uacute;mero" XmlFile="listaSocios.xml" returnvariable="LB_Numero"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default= "Nombre" XmlFile="listaSocios.xml" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion" Default= "Identificaci&oacute;n" XmlFile="listaSocios.xml" returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SociosNegocio" Default= "Socio de Negocios" XmlFile="listaSocios.xml" returnvariable="LB_SociosNegocio"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
<cfoutput>
	#pNavegacion#
</cfoutput>
<cf_web_portlet_start titulo="<cfoutput>#LB_SociosNegocio#</cfoutput>">
<!--- Declaración de Variables --->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="SNcodigo"            returnvariable="SNcodigo">
<cf_dbfunction name="to_char"	args="case when SNcontratos = 1 then 'checked' else '' end " returnvariable="SNcontratos">
<cfset Navegacion ="">
<cfset EL	= '<input type="checkbox" name="chk_@id" @val>'>
<cfset EL	= replace(EL,"'","''","ALL")>
<cfset EL	= replace(EL,"@id","'#_Cat# #SNcodigo# #_Cat#'","ALL")>
<cfset EL	= replace(EL,"@val","'#_Cat# #SNcontratos# #_Cat#'","ALL")>


<cfquery name="rsSNegocios" datasource="#session.dsn#">
	select '#PreserveSingleQuotes(EL)#' as cont,SNcodigo,SNnumero, SNnombre, SNidentificacion, SNcontratos
	from SNegocios
	where Ecodigo=#session.Ecodigo#
	<cfif isdefined("Form.SNnum") and len(trim(Form.SNnum))>
		and upper(SNnumero) like upper('%#Form.SNnum#%')
	</cfif>
	<cfif isdefined("Form.SNnombre") and len(trim(Form.SNnombre))>
		and upper(SNnombre) like upper('%#Form.SNnombre#%')
	</cfif>
	<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo))>
		and upper(SNcodigo) like upper('%#Form.SNcodigo#%')
	</cfif>
	order by SNnumero, SNnombre
</cfquery>

<form name="form1" id="form1" method="post" action="sociosNegocio-sql.cfm">
	<table width="100%" cellspacing="0">
		<tr class="tituloListas">
			<td align="left" >
				<input type="checkbox" name="todos" onclick="javascript: seleccionar();">
				Seleccionar Todos
			</td>
			<td align="right" valign="middle" nowrap>
				N&uacute;mero:&nbsp;
			</td>
			<td align="left">
				<input name="SNnum" type="text" tabindex="1"
				<cfoutput>
					<cfif isdefined("Form.SNnum")>
						value="#Form.SNnum#"
					</cfif>
				</cfoutput>
				size="10" maxlength="20" >
				<div align="right">
				</div>
			</td>
			<td align="right" valign="middle" nowrap>
				Nombre:&nbsp;
			</td>
			<td align="left">
				<input name="SNnombre" type="text" tabindex="1"
				<cfoutput>
					<cfif isdefined("Form.SNnombre")>
						value="#Form.SNnombre#"
					</cfif>
				</cfoutput>
				size="30" maxlength="100" >
				<div align="right">
				</div>
			</td>
			<td align="right" valign="middle" nowrap>
				Identificaci&oacute;n:&nbsp;
			</td>
			<td align="left">
				<input name="SNcodigo" type="text" tabindex="1"
				<cfoutput>
					<cfif isdefined("Form.SNcodigo")>
						value="#Form.SNcodigo#"
					</cfif>
				</cfoutput>
				size="10" maxlength="20" >
				<div align="right">
				</div>
			</td>
			<td>
				<input type="submit" name="Buscar" value="Buscar" class="btnFiltrar" size="5" style="margin: 2px 5px;">
				<input type="submit" name="Limpiar" value="Limpiar" class="btnLimpiar" onclick="return limpiar();">
			</td>
		</tr>
	</table>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#rsSNegocios#"
		desplegar="cont,SNnumero, SNnombre, SNidentificacion"
		etiquetas="Seleccionar,#LB_Numero#, #LB_Nombre#, #LB_Identificacion#"
		formatos="S,S,S,S"
		align="left,left,left,left"
		ira="listaCatalogoSocios.cfm"
		showlink="false" incluyeform="false"
		form_method="post"
		showEmptyListMsg="yes"
		keys="SNnombre"
		MaxRows="20"
		ajustar="S"
		navegacion="#Navegacion#"
		botones = "Aplicar"
		/>
	<cfquery name="checkSocios" datasource="#Session.dsn#">
	select *
	from SNegocios
	where Ecodigo=#session.Ecodigo# order by SNnumero, SNnombre

</cfquery>
</form>
<script type="text/javascript">


function seleccionar()
{
	   var elem = document.getElementById("form1");
	   var cont = 0;
	   var checkal = 20;


        for(var i = 0; i < elem.length; i++)
        {

			if(elem[i].checked){
			cont = cont + 1;
			}

           if((elem[i].name).indexOf("chk_") == 0){
				elem[i].checked=true;
           }
		}

		if(cont == 20){
			document.form1.todos.checked=false;
			for(var i = 0; i < elem.length; i++)
		    {

           		if((elem[i].name).indexOf("chk_") == 0){
					elem[i].checked=false;
           		}
			}
		 }
}

			</script>
<cf_web_portlet_end>
<cf_templatefooter>
