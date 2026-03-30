<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelacion de Documentos'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cf_navegacion name="FechaI" 		navegacion="" session default="">
<cf_navegacion name="FechaF" 		navegacion="" session default="">
<cf_navegacion name="CxC" 		navegacion="" session default="">
<cf_navegacion name="CxP" 		navegacion="" session default="">
<cf_navegacion name="LvarTipo" 		navegacion="" session default="">
<cf_navegacion name="SocioN" 		navegacion="" session default="">
<cf_navegacion name="LvarSocioN" 		navegacion="" session default="">
<cf_navegacion name="Moneda" 		navegacion="" session default="">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfset varNavegacion = "?FechaI=#form.FechaI#&FechaF=#form.FechaF#">
<cfif isdefined("url.PageNum_lista") and len(trim(url.PageNum_lista)) GT 0>
	<cfset varNavegacion = varNavegacion & "&pagina=#url.PageNum_lista#">
<cfelse>
	<cfset varNavegacion = varNavegacion & "&pagina=1">
</cfif>
<cfsetting enablecfoutputonly="yes">

<cfparam name="FechaI" default="">
<cfparam name="FechaF" default="">

<cfquery name="rsEmpresaSeleccionada" datasource="sifinterfaces">
	select 
		Ecodigo,
		CodICTS,
		EcodigoSDCSoin
	from int_ICTS_SOIN
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfoutput>
	<cfset LvarTipo = ''>
	<cfif isdefined("form.CxC") and len(trim(form.CxC))>
		<cfset LvarTipo = 'CC'>
	</cfif>
	<cfif isdefined("form.CxP") and len(trim(form.CxP))>
		<cfset LvarTipo = 'CP'>
	</cfif>
	<cfif isdefined("form.CxC") and len(trim(form.CxC)) and isdefined("form.CxP") and len(trim(form.CxP))>
		<cfset LvarTipo = 'Ambos'>
	</cfif>
	<cfif isdefined("form.LvarTipo") and len(trim(form.LvarTipo))>
		<cfset LvarTipo = form.LvarTipo>
	</cfif>
    
	<cfset LvarSocioN = ''>
	<cfif isdefined("form.SocioN") and len(trim(form.SocioN)) >
		<cfset LvarSocioN = form.SocioN >
	<cfelse>
		<cfset LvarSocioN = 'nada' >
	</cfif>
    <cfif isdefined("form.LvarSocioN") and len(trim(form.LvarSocioN)) >
		<cfset LvarSocioN = form.LvarSocioN>
    </cfif>

	<cfset varNavegacion = varNavegacion & "&LvarTipo=#LvarTipo#&LvarSocioN=#LvarSocioN#">
    <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
    	<cfset varNavegacion = varNavegacion & "&Moneda=#form.Moneda#">
    </cfif>
    <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
    
	<cfquery name="rsDocumentosCancelar" datasource="sifinterfaces">
		select 
			Empresa,
			Modulo,
			NumeroSocio,
			Transaccion,		
            Documento,
            case 
            when isnull(max(convert(varchar,Error)),'') not like '' then
            	convert(varchar,Empresa) #_Cat# '|' #_Cat# Modulo #_Cat# '|' #_Cat# NumeroSocio #_Cat# '|' #_Cat# Transaccion #_Cat# '|' #_Cat# Documento 
            else '0' end as inactiva
		from Interfaz40 
		where Empresa in (#ValueList(rsEmpresaSeleccionada.CodICTS)#)
			and Procesado = 'N'
			<cfif isdefined("LvarTipo") and LvarTipo NEQ 'Ambos'>
			  and Modulo = '#LvarTipo#'
			</cfif>
			<cfif isdefined("LvarSocioN") and LvarSocioN NEQ 'nada'>
			  and NumeroSocio = '#LvarSocioN#'
			 </cfif>
			<cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
			  and CodigoMoneda = '#form.Moneda#'
			</cfif>
		and FechaTransaccion between #vFechaI# and #vFechaF#
        and Procesado = 'N'
        group by Empresa, Modulo, NumeroSocio, Transaccion, Documento 
	</cfquery>
</cfoutput> 

<cfoutput>
 <table>
    <tr>
		<tr> 
		<td width="50">&nbsp;</td>
            <td width="100000"><strong><br>Documentos a Cancelar: </br><strong/></td> </td> 
            <td colspan="2">
			</tr>
	    	<td align="justify" colspan="4"  width="600" height="30">
            	</tr></tr>
            </td>					
			 <tr>
        	<td align="left" colspan="4">
            	<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
                <label for="chkTodos">Seleccionar Todos</label>
            </td>
			</tr>
        </tr>
		   
       <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsDocumentosCancelar#"/>
			<cfinvokeargument name="cortes" value="NumeroSocio"/>
			<cfinvokeargument name="desplegar" value="NumeroSocio,Transaccion,Documento,Modulo"/>
			<cfinvokeargument name="etiquetas" value="Socio,Transacción,Documento,Modulo"/>
			<cfinvokeargument name="formatos" value="S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N"/>
			<cfinvokeargument name="align" value="center, center, center, left"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="irA" value="interfaz40PMI-Consulta.cfm#varNavegacion#"/>   
            <cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="Empresa,Modulo,NumeroSocio,Transaccion,Documento"/>
			<cfinvokeargument name="botones" value="Aplicar,Regresar"/>
            <cfinvokeargument name="navegacion" value=""/>
            <cfinvokeargument name="inactivecol" value="inactiva"/>
		</cfinvoke>
</table>

<cfset session.ListaReg = #rsDocumentosCancelar#>
<script type="text/javascript">
function algunoMarcado(){
		var aplica = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				aplica = document.lista.chk.checked;
			}else{
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Aplicar Registros seleccionados?"));
		} else {
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			return false;
		}
	}

function funcAplicar() {
		if (algunoMarcado())
			document.lista.action = "interfaz40PMI-Motor.cfm";
		else
			return false;
	}
	
function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.lista.chk.length; counter++)
			{				if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = false;
			}
		};
	}
	
function funcRegresar() {
			document.lista.action = "Interfaz40PMI-Param.cfm";		
		}
</script>
</cfoutput> 



