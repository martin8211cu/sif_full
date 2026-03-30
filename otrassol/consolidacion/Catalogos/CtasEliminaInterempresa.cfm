<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 16-04-2010.
 --->
 
<cfparam name= "url.errorCta" default=0>

<cfif isdefined('url.Cuenta') and not isdefined('form.Cuenta')  >
	<cfset form.Cuenta= url.Cuenta>
</cfif>

<cfif isdefined('url.Ecodigodest') and not isdefined('form.EcodigoEmp')  >
	<cfset form.EcodigoEmp = url.Ecodigodest>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>

<cfquery name="rsLista" datasource="#Session.DSN#">
	select b.Eidentificacion as Edescripcion,a.CFCuentaContable as Cuenta,
    a.CFCuentaComplemento as Cuenta2, a.CFdescripcion, 
    a.EcodigoEmp, a.CEcodigo
	from Cons_CtaConEliminaInter1 a
		inner join Empresa b	
			on b.Ereferencia = a.EcodigoEmp
	where a.CEcodigo = #session.Ecodigo#  
	order by a.CEcodigo,a.EcodigoEmp,a.Ccuenta
</cfquery>


<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">
<cf_templateheader title="Otras Soluciones">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cuentas Inter-Empresa">
		<cfinclude template="../../../sif/portlets/pNavegacionCG.cfm">
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr> 
                <td width="53%" valign="top">
                    <cfinclude template="formEliminaInterempresa.cfm">                    
                </td>
            </tr>
             <tr>
                <td width="46%" valign="top"> 
                    <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                        <cfinvokeargument name="query" 				value="#rsLista#"/>
                        <cfinvokeargument name="desplegar" 			value="Edescripcion,Cuenta,Cuenta2,CFdescripcion"/>
						<cfinvokeargument name="etiquetas" 			value="Empresa Origen, Cuenta Eliminaci&oacute;n, Cuenta Destino, Descripci&oacute;n"/>
                        <cfinvokeargument name="formatos" 			value="V,V,V,V"/>
                        <cfinvokeargument name="align" 				value="left,left,left,left"/>
                        <cfinvokeargument name="ajustar" 			value="N,N,N"/>
                        <cfinvokeargument name="irA" 				value="CtasEliminaInterempresa.cfm"/>
                        <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                        <cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/>
                     </cfinvoke>
                </td>                
            </tr>
        </table>            	
    <cf_web_portlet_end>
<cf_templatefooter>