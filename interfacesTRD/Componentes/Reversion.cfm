<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cf_templateheader title="Procesa Reversión Documentos NoFact de Producto">
	  <cf_web_portlet_start titulo="Procesa Reversión Documentos NoFact de Producto">
<!--- Variable de Boton presionado --->
<cfif IsDefined('url.botonsel') and Len(url.botonsel) NEQ 0>
	<cfset Form.botonsel = url.botonsel>
</cfif>

<cfif isdefined("Form.botonsel")>
	<cfif form.botonsel EQ "btnImprimir">
		<cflocation url="/cfmx/interfacesTRD/Componentes/ReversionImprimir.cfm">
	</cfif>
	<!---Se dispara el metodo Aplicar--->
	<cfif form.botonsel EQ "btnAplicar">
		<cfinclude template="SQLAplicaReversion.cfm">
	</cfif>
	<!---Se regresa al menu Inicio--->
	<cfif form.botonsel EQ "btnRegresar">
		<cflocation url="/cfmx/home/">
	</cfif>
</cfif>
<cfquery name="rsReversion" datasource="sifinterfaces">
	select distinct a.Modulo, a.Documento, a.CodigoTransaccion, b.SNcodigoext, a.Producto, a.TipoReversa 
	from DocumentoReversion a 
			inner join #minisifdb#..SNegocios b
			on a.SNcodigo = b.SNcodigo and a.Ecodigo = b.Ecodigo					
	where a.Ecodigo = #session.Ecodigo#
	and a.Procesado = 'N'
	order by a.Modulo,a.Documento,a.CodigoTransaccion, b.SNcodigoext
</cfquery>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsReversion#"/>
	<cfinvokeargument name="cortes" value=""/>
	<cfinvokeargument name="desplegar" value="Modulo, Documento, CodigoTransaccion, SNcodigoext, Producto, TipoReversa"/>
	<cfinvokeargument name="etiquetas" value="Módulo, Documento, Tipo Trans., Socio, Producto, Tipo Reversión"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,S"/>
	<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
	<cfinvokeargument name="align" value="left,left,left,left,left,left"/>
	<cfinvokeargument name="lineaRoja" value=""/>
	<cfinvokeargument name="checkboxes" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetBaseTemplatePath())#"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="formName" value=""/>
	<cfinvokeargument name="PageIndex" value="1"/>
	<cfinvokeargument name="botones" value="Aplicar,Imprimir">
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="True"/>
	<cfinvokeargument name="EmptyListMsg" value="No existen reversiones a procesar"/>
	<cfinvokeargument name="Keys" value=""/>
</cfinvoke>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	function funcAplicar()
	{
		if (confirm('¿Confirma Aplicar las Reversiones pendientes?'))
			{return true;}
		else
			{return false;}
	}
</script>
	  
