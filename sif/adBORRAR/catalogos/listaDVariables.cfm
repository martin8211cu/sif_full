					
					<cfset borrar 	 = "<input name=''imageField'' type=''image'' src=''../../imagenes/Borrar01_S.gif' width=''16'' height=''16'' border=''0'' onclick=''javascript:changeFormActionforDetalles();''>">
						<cfquery name="rsConsulta" dbtype="query">
							select '#borrar#' as Borrar ,DVcodigo as cod, DVdescripcion as descripcion1, DVtipoDato as tdato, DVobligatorio as oblig,DVid as id from CamposForm 	
						</cfquery>
<form name="form3" action="TiposEventos-sql.cfm" method="post">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
							<cfinvokeargument name="query" 				value="#rsConsulta#"/>
							<cfinvokeargument name="desplegar" 			value="cod, descripcion1, tdato, oblig,Borrar"/>
							<cfinvokeargument name="etiquetas" 			value="Codigo,Descripcion,Tipo,Obligatorio,"/>
							<cfinvokeargument name="formatos" 			value="S,S,S,U,US"/>
							<cfinvokeargument name="align" 				value="left,left,left,left,left"/>
							<cfinvokeargument name="formName" 			value="form3"/>
							<cfinvokeargument name="checkboxes" 		value="N"/>
							<cfinvokeargument name="keys" 				value="id"/>
							<cfinvokeargument name="ira" 					value="TiposEventos.cfm"/>
							<cfinvokeargument name="MaxRows" 			value="10"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="PageIndex" 			value="1"/>
						<cfinvokeargument name="incluyeForm" 			value="false"/>
						</cfinvoke>	
</form>	
						
						
						
						