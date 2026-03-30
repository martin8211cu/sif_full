<cfcomponent>
	<cffunction name="TooltipList" access="public">
		<cfargument name="Title"    	type="string"  	required="yes" default="">
        <cfargument name="widthTooltip"    	type="numeric" 	required="yes" default="400">
        <cfargument name="heightTooltip"    type="numeric" 	required="yes" default="370">
        <cfargument name="position"			type="string"   required="yes" default="right">
        <cfargument name="pageIndex"    	type="numeric"  required="yes" default="1">
        <cfargument name="query"    		type="query"    required="no">
        <cfargument name="Asignar"    		type="string"  required="no" default="">
        <cfargument name="sufijo"    		type="string"   required="no" default="">
        <!---<cfargument name="MAS TODOS LOS DEL GRID">--->

        <style>
			.img-Change-ToolTipList {
				background: url("/cfmx/rh/imagenes/back.png") no-repeat scroll 0 0 transparent;
				cursor: pointer;
				display: inline-block;
				height: 20px;
				margin-right: 10px;
				width: 20px;
			}
		</style>
   
			<cfset Arguments.Type = Replace(Replace(UCASE(Arguments.visible),'TRUE','Text','ALL'),'FALSE','hidden','ALL')>
            <cfset Arguments.Type = Replace(Replace(UCASE(Arguments.Type),'YES','Text','ALL'),'NO','hidden','ALL')>
       
        <cfsavecontent variable="link">
        <div class="img-Change-ToolTipList"></div>
        </cfsavecontent>
        <cfset valores = duplicate(Arguments)>
       <cfset StructDelete(valores, "query")>
 <!---       <cfset valores.columnas = Replace(valores.columnas,'+','¡','ALL')>--->
		<cfset valores = Replace(SerializeJSON(valores),'"','!','ALL')>   
         
<cfsavecontent variable="msg">
            <iframe width="<cfoutput>#Arguments.widthTooltip#</cfoutput>" frameborder="0" height="<cfoutput>#Arguments.heightTooltip#</cfoutput>" id="TooltipAjax" name="TooltipAjax" scrolling="auto" src="/cfmx/commons/Componentes/TooltipList.cfc?method=PrintList&Valores=<cfoutput>#valores#</cfoutput>">            	
            </iframe>
        </cfsavecontent> 
        	<cfloop from="1" to="#ListLen(Arguments.Asignar)#" index="i">
            	<input 	id    ="<cfoutput>#TRIM(listGetAt(Arguments.Asignar,i))##sufijo#</cfoutput>" 
                       	name  ="<cfoutput>#TRIM(listGetAt(Arguments.Asignar,i))##sufijo#</cfoutput>" 
                       <cfif isdefined('Arguments.query.#TRIM(listGetAt(Arguments.Asignar,i))#')>
                       	value ="<cfoutput>#evaluate('Arguments.query.'&TRIM(listGetAt(Arguments.Asignar,i)))#</cfoutput>"
                       </cfif>
                       	type  ="<cfoutput>#TRIM(ListGetAt(Arguments.Type,i))#</cfoutput>"
                      	size = "<cfoutput>#TRIM(ListGetAt(Arguments.size,i))#</cfoutput>">
        	</cfloop>
            <cfoutput>
            	<cf_notas link="#link#" position="#Arguments.position#" titulo="#Arguments.Title#" msg="#msg#" width="#Arguments.widthTooltip#" height="#Arguments.heightTooltip#" pageIndex="#Arguments.pageIndex#">
            </cfoutput>
	</cffunction>
    <!---►►►►►►Metodo que pinta el grid dentro del tooltip◄◄◄◄◄◄--->
    <cffunction name="PrintList" access="remote" output="yes">
     	<cfargument name="Valores"  	type="any"  required="no">       
		 <cfset ArgumentsJson  =  Replace(Arguments.valores,'!','"','ALL')>
         <cfset ArgumentsJson =  DeserializeJSON(Replace(ArgumentsJson, " ' ' " ,"+''+",'ALL'))>
    	<link href="/cfmx/plantillas/Cloud/css/TooltipList.css" rel="stylesheet" type="text/css"> 
         <cfinvoke component="commons.Componentes.Grid" method="PlistaJquery">
         	<cfinvokeargument name="caption" 	  	 value="">
            <cfinvokeargument name="etiquetas" 		 value="#ArgumentsJson.etiquetas#">
            <cfinvokeargument name="columnas" 		 value="#ArgumentsJson.columnas#">
            <cfinvokeargument name="tabla" 			 value="#ArgumentsJson.tabla#"> 
            <cfinvokeargument name="filtro"			 value="#ArgumentsJson.filtro#">
            <cfinvokeargument name="desplegar" 		 value="#ArgumentsJson.desplegar#"> 
            <cfinvokeargument name="formato" 		 value="#ArgumentsJson.formato#">
            <cfinvokeargument name="width" 			 value="#ArgumentsJson.width#"> 
            <cfinvokeargument name="sortname" 		 value="#ArgumentsJson.sortname#"> 
            <cfinvokeargument name="key" 			 value="#ArgumentsJson.Asignar#"> 
            <cfif isdefined("ArgumentsJson.mostrarFiltroColumnas")>
             	<cfinvokeargument name="mostrarFiltroColumnas" value="#ArgumentsJson.mostrarFiltroColumnas#"> 
            </cfif>
            <cfif isdefined("ArgumentsJson.PreFiltronombreEmpl")>
             	<cfinvokeargument name="PreFiltronombreEmpl" value="#ArgumentsJson.PreFiltronombreEmpl#"> 
            </cfif>
            <cfinvokeargument name="fnClick" 		 value="Seleccion"> 
            <cfinvokeargument name="PageIndex" 		 value="#ArgumentsJson.PageIndex#"> 
            <cfinvokeargument name="ModoProgramador" value="#ArgumentsJson.ModoProgramador#">
    	</cfinvoke>
          <script language="javascript" type="text/javascript">
			function Seleccion(ID){
				idA = ID.split("|"); 
				$.each(['<cfoutput>#replace(ArgumentsJson.Asignar,',',"','",'ALL')#</cfoutput>'], function(index, value)
				{
					window.parent.document.getElementById(''+value+'<cfoutput>#ArgumentsJson.sufijo#</cfoutput>').value = idA[index];
				});
				window.parent.fnCerrarToolTip_<cfoutput>#ArgumentsJson.PageIndex#</cfoutput>();	
				<cfif isdefined('ArgumentsJson.fnClick') and LEN(TRIM(ArgumentsJson.fnClick))>
					<cfoutput>window.parent.#ArgumentsJson.fnClick#</cfoutput>(ID);
				</cfif>
			}
		</script>
    </cffunction>
</cfcomponent>