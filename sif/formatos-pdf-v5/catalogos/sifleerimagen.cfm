<cfparam name="Attributes.imgname" default="sifimg"  type="string">
<cfparam name="Attributes.Tabla" default=""  type="string">
<cfparam name="Attributes.Campo" default=""  type="string">
<cfparam name="Attributes.Condicion" default=""  type="string">
<cfparam name="Attributes.Conexion" default="#Session.DSN#"  type="string">
<cfparam name="Attributes.width" default="61"  type="numeric">
<cfparam name="Attributes.height" default="39"  type="numeric">
<cfparam name="Attributes.autosize" default="true"  type="boolean">
<cfparam name="Attributes.border" default="false"  type="boolean">
<cfparam name="Attributes.bordercolor" default="##FFFFFF"  type="string">
<cfparam name="Attributes.ruta" default="sifleerimagencont.cfm"  type="string">

<cfset sql ="select " & Attributes.Campo & " from " & Attributes.Tabla & " where " & replacenocase(Attributes.Condicion,'where','')>
<cfset codigo = "#Attributes.Tabla##cfid##Attributes.imgname#" & GetFileFromPath(GetTemplatePath())>
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
	<cfoutput>
	<cfset tipo = "image/" & iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))>
	<img 
		name="#Attributes.imgname#" 
		src="#Attributes.ruta#?tipoimg=#iif(ucase(ts) EQ 'GIF',de('gif'),de('jpg'))#&codigo=#codigo#" 
		<cfif not attributes.autosize>width="#Attributes.width#" height="#Attributes.height#"</cfif> 
		<cfif attributes.border>border="1" bodercolor="#Attributes.bordercolor#"<cfelse>border="0"</cfif>>  		
	</cfoutput>
