<cfparam name="Attributes.imgname" default="sifimg"  type="string">
<cfparam name="Attributes.Tabla" default=""  type="string">
<cfparam name="Attributes.Campo" default=""  type="string">
<cfparam name="Attributes.Condicion" default=""  type="string">
<cfparam name="Attributes.Conexion" default="#Session.DSN#"  type="string">
<cfparam name="Attributes.width" default="-1"  type="numeric">
<cfparam name="Attributes.height" default="-1"  type="numeric">
<cfparam name="Attributes.autosize" default="true"  type="boolean">
<cfparam name="Attributes.border" default="false"  type="boolean">
<cfparam name="Attributes.bordercolor" default="##FFFFFF"  type="string">
<cfparam name="Attributes.desplegar" default="true"  type="string">
<cfparam name="Attributes.ruta" default="/UtilesExt/sifleerimagencontEXT.cfm"  type="string">

<cfif Attributes.autosize>
	  <cfset Attributes.height = -1>
	  <cfset Attributes.width  = -1>
<cfelseif Attributes.height EQ -1 AND Attributes.width EQ -1>
	<cfset Attributes.width = 61>
	<cfset Attributes.height = 39>
</cfif> 


<cfset sql ="select " & Attributes.Campo & " from " & Attributes.Tabla & " where " & replacenocase(Attributes.Condicion,'where','')>
<cfset codigo = "#Attributes.Tabla##session.RHOid#">
<cfif Attributes.Tabla EQ "" or attributes.Campo EQ "">
	<cfexit method="exittag">
</cfif>

<cfquery name="rs_Imagen" datasource="#Attributes.Conexion#">
	#PreserveSingleQuotes(sql)#
</cfquery>


	<!--- Procesar el BLOB --->
	<cfset ts = "">
	<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
	<cfif isArray(#Evaluate("rs_Imagen.#Attributes.Campo#")#)>
			<cfset miarreglo=ListtoArray(ArraytoList(#Evaluate("rs_Imagen.#Attributes.Campo#")#,","),",")>
			<cfloop index="i" from="1" to="3">
				<cfif miarreglo[i] LT 0>
					<cfset miarreglo[i]=miarreglo[i]+256>
				</cfif>
			</cfloop>
			<cfloop index="i" from="1" to="3">
				<cfset ts = ts & "#chr(miarreglo[i])#">
			</cfloop>
	
	</cfif>
	<cffile 
		action="write" 
		nameconflict="overwrite" 
		file="#gettempdirectory()##codigo#.#iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))#"
		output="#Evaluate('rs_Imagen.#Attributes.Campo#')#">

	<cfset Request.tipoimg = "#iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))#">
	<cfset Request.imgcodigo = codigo>


<cfif Attributes.desplegar>

<cfoutput>
<cfset tipo = "image/" & iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))>
<img 
	name="#Attributes.imgname#" 
	src="/images/UserIcon.png" 
	<cfif Attributes.width NEQ -1> width="#Attributes.width#"</cfif><cfif Attributes.height NEQ -1> height="#Attributes.height#"</cfif> 
	<cfif attributes.border>border="1" bodercolor="#Attributes.bordercolor#"<cfelse>border="0"</cfif>>  		
</cfoutput>
		

<!--- 	<cfif rs_Imagen.recordCount GT 0>
		<cfoutput>
	    <cfset tipo = "image/" & iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))>
		<cfdump var="#gettempdirectory()##codigo#.#iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))#">
		<img 
            name="#Attributes.imgname#" 
			src="#Attributes.ruta#?tipoimg=#iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))#&amp;codigo=#codigo#&amp;hash=#Hash(Attributes.Condicion&Attributes.Tabla&Attributes.Campo)#" 
            <cfif Attributes.width NEQ -1> width="#Attributes.width#"</cfif><cfif Attributes.height NEQ -1> height="#Attributes.height#"</cfif> 
            <cfif attributes.border>border="1" bodercolor="#Attributes.bordercolor#"<cfelse>border="0"</cfif>>  		
        </cfoutput>
	<cfelse>
		<cfoutput>
        <cfset tipo = "image/" & iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))>
        <img 
            name="#Attributes.imgname#" 
            src="/images/UserIcon.png" 
            <cfif Attributes.width NEQ -1> width="#Attributes.width#"</cfif><cfif Attributes.height NEQ -1> height="#Attributes.height#"</cfif> 
            <cfif attributes.border>border="1" bodercolor="#Attributes.bordercolor#"<cfelse>border="0"</cfif>>  		
        </cfoutput>
	</cfif> --->
</cfif>			