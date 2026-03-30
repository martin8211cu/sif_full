
<cfparam name="form.CancelarOrdenes" default="1">
<cfif form.CancelarOrdenes eq 1>
	<cfif isdefined("form.chk") 
            and len(trim(form.chk)) 
            and isdefined("form.btnCancelar")
            and isdefined("form.textarea_justificacion1") 
            and len(trim(form.textarea_justificacion1))>
        <cfset EOjustificacion = form.textarea_justificacion1>
        <cfloop list="#form.chk#" index="EOidorden">		
            <cfinvoke 
                    component="sif.Componentes.CM_CancelaOC"
                    method="CM_CancelaOC"
                    returnvariable="NAPcancel">
                <cfinvokeargument name="EOidorden" value="#EOidorden#">
                <cfinvokeargument name="EOjustificacion" value="#EOjustificacion#">
                <cfinvokeargument name="Ecodigo" value="#form.Ecodigo_f#">
            </cfinvoke>
        </cfloop>
    </cfif>
 <cfelseif form.CancelarOrdenes eq 2><!--- Para la cancelacion por linea de Orden de Compra --->
	<cfif isdefined("form.chk") 
                and len(trim(form.chk)) 
                and isdefined("form.btnCancelar2") 
                and isdefined("form.textarea_justificacion2") 
                and form.textarea_justificacion2 neq "">
        <cfset EOjustificacion = form.textarea_justificacion2>
        <cfloop list="#form.chk#" index="llaves">
                <cfset llaves2 = ListToArray(llaves,'|')>
                <cfset DOcantcancel = "saldo_" & llaves2[1] & "_" & llaves2[2]>
            <cfinvoke 
                    component="sif.Componentes.CM_CancelaOC"
                    method="CM_CancelaOC_Lineas"
                    returnvariable="NAPcancel">
                        <cfinvokeargument name="EOidorden" value="#llaves2[1]#">
                        <cfinvokeargument name="DOlinea" value="#llaves2[2]#">
                        <cfinvokeargument name="DOcantcancel" value="#form[DOcantcancel]#"> 
                        <cfinvokeargument name="EOjustificacion" value="#EOjustificacion#">
                        <cfinvokeargument name="Ecodigo" value="#form.Ecodigo_f#">
            </cfinvoke> 
        </cfloop>
    </cfif>   
</cfif>
