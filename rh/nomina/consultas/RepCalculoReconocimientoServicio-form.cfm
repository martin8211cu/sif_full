<cfset t = createObject("component", "sif.Componentes.Translate")>   

<!--- Etiquetas de traduccion --->
<cfset LB_Anno = t.translate('LB_Anno','Año','/rh/generales.xml')/>
<cfset LB_Mes = t.translate('LB_Mes','Mes','/rh/generales.xml')/>
<cfset LB_Formato = t.translate('LB_Formato','Formato','/rh/generales.xml')/>
<cfset LB_HTML = t.translate('LB_HTML','HTML','/rh/generales.xml')>
<cfset LB_PDF = t.translate('LB_PDF','PDF','/rh/generales.xml')>
<cfset LB_Excel = t.translate('LB_Excel','Excel','/rh/generales.xml')>
<cfset LB_Concepto_de_Pago = t.translate('LB_Concepto_de_Pago','Concepto de Pago','/rh/generales.xml')>
<cfset LB_Consultar = t.translate('LB_Consultar','Consultar','/rh/generales.xml')>
<cfset LB_Limpiar = t.translate('LB_Limpiar','Limpiar','/rh/generales.xml')> 


<!--- Consulta si empresa(session) tiene habilitada la opcion de permitir consultas corporativas --->
<cfquery name="rsPmtConsCorp" datasource="#Session.DSN#">
    select Pvalor
    from RHParametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and Pcodigo = 2715
</cfquery>

<cfif rsPmtConsCorp.recordCount gt 0 and rsPmtConsCorp.Pvalor eq '1'>
    <cfset lvPmtConsCorp = 1 >
<cfelse>
    <cfset lvPmtConsCorp = 0 >  
</cfif>


<!--- obtiene meses para el idioma --->
<cfquery datasource="sifcontrol" name="rsMeses">
    select VSdesc, ltrim(rtrim(VSvalor)) as VSvalor
    from VSidioma 
    where VSgrupo = 1 and Iid = (select Iid from Idiomas where Icodigo = '#session.Idioma#')
    order by <cf_dbfunction name="to_number" args="VSvalor">
</cfquery>

  
<form class="bs-example form-horizontal" action="RepCalculoReconocimientoServicio-sql.cfm" method="post" name="form1" style="margin:0">
    <cfoutput>
    	<div class="form-group">
    		<label for="DCcodigo" class="col-md-4 control-label">#LB_Mes#:</label>
    		<div class="col-md-2">
            	<select class="form-control" id="CPmes" name="CPmes">
            		<cfloop query="rsMeses">
    	            	<option value="#VSvalor#">#VSdesc#</option>
    	        	</cfloop>
    	        </select>
            </div>
        </div>   

    	<div class="form-group">
    		<label for="DCcodigo" class="col-md-4 control-label">#LB_Anno#:</label>
    		<div class="col-md-2">
            	<select class="form-control" id="CPperiodo" name="CPperiodo">
                	<cfloop from="#year(now())#" to="#year(now())-15#" index="i" step="-1">
                		<option value="#i#">#i#</option>
                	</cfloop>
                </select>
            </div>
    	</div>

       	<!--- concepto de pago que tiene la formula de semanas --->
        <div class="form-group">	
        	<label for="CIcodigo" class="col-md-4 control-label"><strong>#LB_Concepto_de_Pago#:</strong></label>
        	<div class="col-md-4">
        		<cf_rhcincidentes ExcluirTipo="0,1,2">
    		</div>	
        </div>	

        <!--- Valida si esta habilitado las consultas corporativas --->
        <cfif lvPmtConsCorp eq 1>
            <!--- Arbol con la lista de empresas para consulta coorporativa --->
            <div class="form-group">
                <label class="col-md-4 control-label"></label>
                <div class="col-md-4">
                    <cf_rharbolempresas>
                </div>  
            </div>  
        </cfif>     

    	<div class="form-group">
    		<label for="formato" class="col-md-4 control-label">#LB_Formato#:</label>
    		<div class="col-md-2">
            	<select class="form-control"  name="formato">
            		<option value="html">#LB_HTML#</option>
            		<option value="excel">#LB_Excel#</option>
            		<option value="pdf">#LB_PDF#</option>
              	</select>
            </div>
    	</div>

    	<div class="form-group">
            <div class="col-sm-7 col-sm-offset-4">
        		<input type="submit" name="Consultar" class="btnConsultar" value="#LB_Consultar#">
                <input type="reset" name="Limpiar" class="btnLimpiar" value="#LB_Limpiar#" onclick="fnLimpiar()">
            </div>    
    	</div>	
    </cfoutput>    
</form>


<cf_qforms form="form1">
<script type="text/javascript">
    $(document).ready(function(){
        fnLimpiar();
    });

	objForm.CIid.required = true;
	objForm.CIid.description = '<cfoutput>#LB_Concepto_de_Pago#</cfoutput>';

	// Funcion para inicializar(reset) los elementos del form
    function fnLimpiar(){
        $('form[name=form1]')[0].reset();
        $('.listTree').listTree('deselectAll');
        $(".divArbol").hide();
    }
</script>


