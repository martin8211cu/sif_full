<cfif not isdefined('form.ANHid') or len(trim(form.ANHid)) EQ 0>
	<cfset form.ANHid = url.ANHid>
</cfif>

<cfif not isdefined('form.ANHid')>
	<cf_errorCode	code = "51647" msg = "Error en Invocación: No se envio codigo de Homologación de cuenta (ANHid)">
</cfif>
<cfquery name="rslista" datasource="#session.dsn#">
	select ANHCid,ANHid,ANHCcodigo,ANHCdescripcion, '' as x
		from ANhomologacionCta
		where ANHid = #form.ANHid#
		 <cfif isdefined ('form.filtro_ANHCcodigo') and len(trim(form.filtro_ANHCcodigo)) gt 0>
			and lower(ANHCcodigo) like lower('%#form.filtro_ANHCcodigo#%')
		</cfif>
		<cfif isdefined ('form.filtro_ANHCdescripcion') and len(trim(form.filtro_ANHCdescripcion)) gt 0>
			and lower(ANHCdescripcion) like lower('%#form.filtro_ANHCdescripcion#%')
	    </cfif>
</cfquery>	
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" 			  value="#rslista#"/>
	<cfinvokeargument name="desplegar"  	  value="ANHCcodigo,ANHCdescripcion"/>
	<cfinvokeargument name="etiquetas"  	  value="Cuenta,Descripción Cuenta Homologación"/>
	<cfinvokeargument name="formatos"   	  value="S,S"/>
	<cfinvokeargument name="align" 			  value="left,left"/>
	<cfinvokeargument name="ajustar"   		  value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys"             value="ANHid,ANHCid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="mostrar_filtro"   value="true"/>
	<cfinvokeargument name="irA"              value="ANhomologacionCta.cfm?ANHid=#form.ANHid#"/>
	<cfinvokeargument name="pageindex"        value="1"/>
	<cfinvokeargument name="formname"        value="lista1"/>
  <cfinvokeargument name="usaAJAX" 			  value="yes"/>
  <cfinvokeargument name="conexion" 		  value="#session.DSN#"/>
</cfinvoke> 

<script language="javascript" type="text/javascript">
	function filtrar_Plista1(){
		document.form2.action='ANhomologacionCta.cfm?ANHid=#form.ANHid#';
		document.form2.submit;
	}
</script>