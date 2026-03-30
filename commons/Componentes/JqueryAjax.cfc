<cfcomponent>
	<cffunction name="ajax" access="public">
    	<cfargument name="Funcion" 	  	type="string" required="no" default="FunctionAjax">
        <cfargument name="data" 		type="string" required="no" default="">
        <cfargument name="url" 		  	type="string" required="no" default="">
        <cfargument name="mensajeExito" type="string" required="no" default="">
        <cfargument name="type" 		type="string" required="no" default="POST" hint="POST=FORM / GET=URL">
        <cfset Arguments.DataArray = ListToArray(Arguments.data)>
        <cf_importJQuery>
        <cfset param ="'Ajax=true'">
        <cfloop array="#Arguments.DataArray#" index="i">
			<cfset param = "#param#+'&#i#='+#i#">
		</cfloop>
        	<cfset param = '#param#'>
      
		<cfoutput>
    	<script language="javascript" type="text/javascript">
			var erro="false";
			<!---►►Funcion Ajax◄◄--->
			function #Arguments.function#(#Arguments.data#){
				$.ajax({
								url: "#Arguments.url#",
								async: false,
								dataType: "html",
								data: #param#,
								success: function(data){
									fnBuscarError(data);
									<cfif LEN(TRIM(Arguments.mensajeExito))>
										if(erro == 'false') alert('#Arguments.mensajeExito#');
									</cfif>
								},
								
								error: function(jqXHR, textStatus, errorThrown) { 
									alert('errorThrown'); 
									},
								type: "#Arguments.type#"
						});
			}
		<!---►►Funcion para Buscar Errores◄◄--->	
		function fnBuscarError(data){
	
	 for(valor=0; valor<data.length; valor++){
			contador=0; var uno =""; var dos=""; var tres=""; var cuatro=""; var cinco=""; var palabra="";
			for(i=valor; i<data.length && contador<5; i++){
				 if(0==contador){
					 uno = data.charAt(i);
				 }
				 else if(1==contador) {
					 dos = data.charAt(i);
				 }
				 else if(2==contador){
					 tres = data.charAt(i); 
				 }
				 else if(3==contador){
					 cuatro = data.charAt(i);  
				 }
				 else if(4==contador){
					 cinco = data.charAt(i);
					 palabra= uno+dos+tres+cuatro+cinco;
						 if(palabra=="Error"|palabra=="error"|palabra=="ERROR"){
							<!--- document.fmEmpleadoNomina.action ="/cfmx/rh/Cloud/Nomina/Error.cfm";
							 document.fmEmpleadoNomina.HEERR.value = data;
							 document.fmEmpleadoNomina.submit();--->
							 alert(data);
							 erro="true";
						 }
				 }
					 contador++;						 
			 }
	 }
}
		</script>
    	</cfoutput>
	</cffunction>
</cfcomponent>