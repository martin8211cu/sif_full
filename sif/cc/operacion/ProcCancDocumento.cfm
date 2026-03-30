<!---<cf_dump var="#form#">--->
<cfset varControlFlujo = true>
<cfset varPosteo = false>

<cfif isdefined("form.btnCancelar_Documento")>
	<!--- Manda llamar al proceso de Cancelacion de Documentos --->
    <cfinvoke 
		component="sif.Componentes.CC_CancelacionDoc" 
		debug="false"
		CCTcodigo="#Form.CCTcodigoC#"
		Ddocumento="#Form.DdocumentoC#"
        HDid = "#Form.HDidC#"
        method="Cancelacion"
	/> 
</cfif>

<cfif isdefined("form.btnCancelar")>
	<cfif (isdefined("Form.chk"))>
    	<cfset chequeados = ListToArray(Form.chk,",")>
        <cfset limiteU = ArrayLen(chequeados)>
		<cfloop from="1" to="#limiteU#" index="idx">
        	<cfset datos = ListToArray(chequeados[idx],"|")>
			<!--- Manda llamar al proceso de Cancelacion de Documentos --->
    		<cfinvoke 
				component="sif.Componentes.CC_CancelacionDoc"
				debug="false"
				CCTcodigo="#datos[2]#"
				HDid = "#datos[3]#"
				Ddocumento="#datos[1]#"
		        method="Cancelacion"
			/> 
		</cfloop>
    </cfif>
</cfif>    	

<cfif isdefined("form.DdocumentoREF") and len(trim(form.DdocumentoREF)) and isdefined("form.CCTcodigoREF") and len(trim(form.CCTcodigoREF)) and not isdefined("form.btnCancelar") and not isdefined("form.btnCancelar_Documento")>
	<cfinclude template="formCancDocumento.cfm">
<cfelse>
	<cfinclude template="ListaCancDocumento.cfm">
</cfif>


