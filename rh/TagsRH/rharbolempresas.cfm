<cfoutput>
	<cfset request.a = 1>
	<cfinvoke component="sif.Componentes.Translate" method="translate" key="LB_EsCorporativo" default="Es corporativo" xmlFile="/rh/generales.xml" returnvariable="LB_EsCorporativo">
	<cfparam name="attributes.conexion" default="#session.dsn#">
	
	<div class="form-group">
		<label class="col-sm-3 control-label">
	    	<input type="checkbox" name="esCorporativo" id="esCorporativo" onClick="fnShowTree()"> <strong>#LB_EsCorporativo#?</strong>
	    </label>
	</div>

	<!--- Lista de empresas que pertenecen a una coorporacion --->
	<div class="form-group divArbol" style="display:none">
		<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaEmpresasPermiso" returnvariable="EmpresaLista">

		<cf_translatedata name="get" tabla="Empresas" col="e.Edescripcion" returnvariable="LvarEdescripcion">
	    <cfquery datasource="#attributes.conexion#" name="datosArbol" maxrows="50">
	        select #LvarEdescripcion# as Edescripcion, e.Ecodigo
	        from Empresas e
	        where cliente_empresarial = #session.CEcodigo#
	        <cfif len(trim(EmpresaLista))>
	        	and e.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#EmpresaLista#" list="true">)
	        </cfif>
	        order by #LvarEdescripcion#
	    </cfquery> 

	    <cfsavecontent variable="data">
	    {
	        "key":"0",
	        "label":"<cf_translate key="LB_TodasLasEmpresas" xmlFile="/rh/generales.xml">Todas las Empresas</cf_translate>",
	        "values":[
		                <cfloop query="datosArbol">
		                {
	                        "key": "#trim(Ecodigo)#",
	                        "label": "#trim(Edescripcion)#"
		                }
		                <cfif currentrow neq recordcount>,</cfif>
		                </cfloop>
	                ]
	    }
	    </cfsavecontent>

	   <div class="col-lg-12">
	    	<cf_jtree data="#data#" formatoJSON="false">
	    </div>
	</div>	
	
	<script type="text/javascript">
		function fnShowTree(){
			if (document.getElementById("esCorporativo").checked == true)
				$('.divArbol').show(200);
			else{
				$('.divArbol').hide(200);
				$('.listTree').listTree('deselectAll');
			}	 
		}
	</script>
</cfoutput>