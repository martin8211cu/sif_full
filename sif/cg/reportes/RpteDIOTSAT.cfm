
<cfset MesD = Form.mesd>
<cfset MesH = Form.mesh>
<cfset PeriodoD = Form.periodod>
<cfset PeriodoH = Form.periodoh>


<cfset archivos = ArrayNew(1)> <!--- en este array se agregaran las rutas de mis archivos --->

<!---<cfloop condition="indicador LESS THAN OR EQUAL TO  limitador">--->
	
	<cfinvoke component="sif.cg.reportes.RpteDIOTSQL" method="ConsultaTablaReporte" returnvariable="rsRPTdiot">
	</cfinvoke>	
	

	<!--- obtengo un directorio y nombre para mi archivo temporal --->
	<cfset txtfile= GetTempFile(getTempDirectory(), "DIOT_#MesD##PeriodoD#_#MesH##PeriodoH#")>
	<!--- utilizando expresiones regulares le indico que todo despues de DIOT e incluyendo DIOT lo sustituya por DIOTindicador--->
	<cfset txtfile = REReplace("#txtfile#", "DIOT[0-9a-zA-Z]+", "DIOT_#MesD##PeriodoD#_#MesH##PeriodoH#") /> 
	<!--- sustituyo la extensión que genera el archivo tempral --->
	<cfset txtfile = replaceNocase(txtfile, '.tmp', '.txt') />

	<cfif fileExists("#txtfile#")>
		<cffile action="Delete" file="#txtfile#">  <!--- se debe de eliminar en caso de que el archivo exista de lo contrario estará corrupto--->

		<!--- repito el proceso para obtener la ruta y el archivo --->
		<cfset txtfile= GetTempFile(getTempDirectory(), "DIOT_#MesD##PeriodoD#_#MesH##PeriodoH#")>
		<!--- repito el proceso para obtener la ruta y el archivo --->
		<cfset txtfile = REReplace("#txtfile#", "DIOT[0-9a-zA-Z]+", "DIOT_#MesD##PeriodoD#_#MesH##PeriodoH#") /> 
		<!--- repito el proceso para obtener la ruta y el archivo --->
		<cfset txtfile = replaceNocase(txtfile, '.tmp', '.txt') />
	</cfif>	
	
	<cfif rsRPTdiot.recordcount GT 0>
	<cfset ArrayAppend(archivos, "#txtfile#")>
	<cfloop query="rsRPTdiot">
    	        
	<!---Inicia Revision Longitudes de Campos--->
    	<cfif isdefined('rsRPTdiot.SNidentificacion') and rsRPTdiot.SNidentificacion NEQ ''>
			<cfset rsRFC = len(#rsRPTdiot.SNidentificacion#)>
            <cfif rsRFC LT 12 or rsRFC GT 13>
                <cf_errorCode	code = "80027" msg = "La longitud del RFC debe ser de 12 o 13 caracteres.">
            </cfif>	
        </cfif>
        
        <cfif isdefined('rsRPTdiot.IdFisc') and rsRPTdiot.IdFisc NEQ ''>
			<cfset rsIdFisc = len(#rsRPTdiot.IdFisc#)>
            <cfif rsIdFisc GT 40>
                <cf_errorCode	code = "80033" msg = "La longitud del ID fiscal NO debe tener mas de 40 caracteres.">
            </cfif>	
        </cfif>
        
        <cfif isdefined('rsRPTdiot.SNnombre') and rsRPTdiot.SNnombre NEQ ''>
			<cfset rsNombre = len(#rsRPTdiot.SNnombre#)>
            <cfif rsNombre GT 43>
                <cf_errorCode	code = "80033" msg = "La longitud del Nombre NO debe tener mas de 43 caracteres.">
            </cfif>
        </cfif>
        
        <cfif isdefined('rsRPTdiot.Ppais') and rsRPTdiot.Ppais NEQ ''>
			<cfset rsPais = len(#rsRPTdiot.Ppais#)>
            <cfif rsPais GT 2>
                <cf_errorCode	code = "80034" msg = "La longitud del Pais de Residencia NO debe tener mas de 2 caracteres.">
            </cfif>	
        </cfif>
        
        <cfif isdefined('rsRPTdiot.Nacional') and rsRPTdiot.Nacional NEQ ''>
			<cfset rsNacional = len(#rsRPTdiot.Nacional#)>
            <cfif rsNacional GT 40>
                <cf_errorCode	code = "80035" msg = "La longitud de la Nacionalidad NO debe tener mas de 40 caracteres.">
            </cfif>
       	</cfif>
          
    <!---Termina Revision de Longitudes de Campos--->


		<cfif rsRPTdiot.DIOTcodigo eq 5>
        		<cfif rsRPTdiot.DIOTopcodigo NEQ 03 and  rsRPTdiot.DIOTopcodigo NEQ 85>
                    <cf_errorCode	code = "80026" msg = "La operación Arrendamientos de Inmuebles(06) no es valida para los proveedores extranjeros(05).">
                </cfif>
                
				<cfif not isdefined('rsRPTdiot.SNnombre') or rsRPTdiot.SNnombre EQ '' >
                     <cf_errorCode	code = "80028" msg = "El nombre para un proveedor de tipo extranjero (#rsRPTdiot.DIOTcodigo#) es necesario.">
                </cfif>
                
				<cfif not isdefined('rsRPTdiot.Ppais') or rsRPTdiot.Ppais EQ '' >
                    <cf_errorCode	code = "80029" msg = "El País de residencia es obligatorio para proveedores extranjeros(05).">
                </cfif>
                
				<cfif not isdefined('rsRPTdiot.Nacional') or rsRPTdiot.Nacional EQ '' >
                     <cf_errorCode	code = "80030" msg = "La nacionalidad es un campo obligatorio para proveedores extranjeros(05).">
                </cfif> 

		</cfif>
        
        <cfif rsRPTdiot.DIOTcodigo eq 4>		
			<cfif not isdefined('rsRPTdiot.SNidentificacion') or rsRPTdiot.SNidentificacion EQ ''>
                <cf_errorCode	code = "80031" msg = "Para el tipo de proveedor Nacional(04) es necesario incluir RFC (Error con el registro #rsRPTdiot.SNnombre#)">
			</cfif>
		</cfif>
        
        <cfif not isdefined('rsRPTdiot.DIOTopcodigo') or rsRPTdiot.DIOTopcodigo eq "">    
            <cf_errorCode	code = "80032" msg = "No se ha definido el tipo de operación DIOT para el Socio de Negocio #rsRPTdiot.SNnombre#">   
        </cfif>
        

        <cfset varNombre =  #rsRPTdiot.SNnombre#>
        <cfset varNombre = Replace("#varNombre#", "@", "","ALL") /> 
        <cfset varNombre = Replace("#varNombre#", "´", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", "%", "","ALL") /> 
        <cfset varNombre = Replace("#varNombre#", "!", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", "¡", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", "$", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", ".", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", "&", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", ",", "","ALL") />
        <cfset varNombre = Replace("#varNombre#", "-", "","ALL") />
		
        <cfset varPais = #rsRPTdiot.Ppais#/>

        <cfif rsRPTdiot.DIOTcodigo NEQ 5>
        	<cfset varNombre = ''/>
        	<cfset varPais = ''/>
        </cfif>
        
        <cfif rsRPTdiot.DIOTcodigo EQ 5 or rsRPTdiot.DIOTcodigo EQ 15>
        	<cfset rsRPTdiot.IVAotrosPagados = #rsRPTdiot.IVAotrosPagados#/>
            <cfset rsRPTdiot.IVABienesServiciosPagados = #rsRPTdiot.IVABienesServiciosPagados#/>
        <cfelse>
        	<cfset rsRPTdiot.IVAotrosPagados = ''/>
        	<cfset rsRPTdiot.IVABienesServiciosPagados = ''/>
        </cfif>
        
        
        <cfset varNacional =  #rsRPTdiot.Nacional#>
        <cfset varNacional = Replace("#varNacional#", "@", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "%", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "!", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "¡", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", ".", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "$", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "¿", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "?", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "´", "","ALL") />
        <cfset varNacional = Replace("#varNacional#", "`", "","ALL") />
        

		<cffile action = "append" 
			charset="iso-8859-1" 
			file="#txtfile#"			
			output="#numberformat(rsRPTdiot.DIOTcodigo,"00")#|#numberformat(rsRPTdiot.DIOTopcodigo,"00")#|#replace(rsRPTdiot.SNidentificacion, "-", "", "All")#|#replace(rsRPTdiot.IdFisc, ",", "", "All")#|#varNombre#|#varPais#|#varNacional#|#LsNumberFormat(rsRPTdiot.IVAOtros,0)#|#LsNumberFormat(rsRPTdiot.IVABienesServicios,0)#||||||#LsNumberFormat(rsRPTdiot.IVAotrosPagados,'')#||||#LsNumberFormat(rsRPTdiot.IVAcero,0)#|#LsNumberFormat(rsRPTdiot.IVAExentoOtros,0)#|#LsNumberFormat(rsRPTdiot.MontoRetIVA,0)#|0|">

	</cfloop>
<cfset zipUrl = GetTempFile(getTempDirectory(), "ZIPDIOT")>

<cfzip file="#zipUrl#" overwrite="true" >
	<cfloop array="#archivos#" index="in">
		<cfzipparam source="#in#" >	
	</cfloop>
</cfzip>
<cfheader name="Content-Disposition" value="attachment;filename=DIOT.zip">
<cfcontent file="#zipUrl#" type="application/zip" deletefile="yes">

<p align="center">Se gener&oacute; el archivo</p>
<cfelse>
    <cf_errorCode	code = "80025" msg = "No existen registros que coincidan con los parametros de búsqueda.">
    	
</cfif>