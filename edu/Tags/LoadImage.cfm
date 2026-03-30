<cfparam name="Attributes.Conexion" default="#Session.Edu.DSN#"  type="string">
<!--- Atributos para constuir query, todos los campos son obligatorios --->
<cfparam name="Attributes.tabla" default="" type="string">
<cfparam name="Attributes.columnas" default="" type="string">
<cfparam name="Attributes.condicion" default="" type="string">

<!--- Nombre de los campos del query, el codigo y el contenido son obligatorios --->
<cfparam name="Attributes.codigo" default="codigo" type="string">
<cfparam name="Attributes.contenido" default="contenido" type="string">
<cfparam name="Attributes.nombre" default="nombre" type="string">
<cfparam name="Attributes.tipo_contenido" default="tipo_contenido" type="string">

<cfparam name="Attributes.fileToDownload" default="/cfmx/edu/Utiles/LoadImageArch.cfm" type="string">
<cfparam name="Attributes.imgname" default="imagen" type="string">
<cfparam name="Attributes.alt" default="" type="string">
<cfparam name="Attributes.width" default="0"  type="numeric">
<cfparam name="Attributes.height" default="0"  type="numeric">
<cfparam name="Attributes.border" default="false"  type="boolean">

<cfif Len(Trim(Attributes.tabla)) EQ 0 
   or Len(Trim(attributes.columnas)) EQ 0
   or Len(Trim(attributes.condicion)) EQ 0
   or Len(Trim(Session.Edu.Usucodigo)) EQ 0>
	<cfexit method="exittag">
</cfif>

<cfset sql ="select " & Attributes.columnas & " from " & Attributes.tabla & " where " & replacenocase(Attributes.condicion,'where','')>
<cfquery name="rsImagen" datasource="#Attributes.Conexion#">
	#PreserveSingleQuotes(sql)#
</cfquery>

<cfif isdefined("rsImagen.#Attributes.codigo#") and isdefined("rsImagen.#Attributes.contenido#")>
	<cfset ts = "">
	<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
	<cfif isArray(#Evaluate("rsImagen.#Attributes.contenido#")#)>
			<cfset miarreglo=ListtoArray(ArraytoList(#Evaluate("rsImagen.#Attributes.contenido#")#,","),",")>
			<cfloop index="i" from="1" to="3">
				<cfif miarreglo[i] LT 0>
					<cfset miarreglo[i]=miarreglo[i]+256>
				</cfif>
			</cfloop>
			<cfloop index="i" from="1" to="3">
				<cfset ts = ts & "#chr(miarreglo[i])#">
			</cfloop>
	</cfif>
	
	<cfoutput>
	<cffile action="write" nameconflict="overwrite" 
	        file="#gettempdirectory()##Session.Edu.Usucodigo##Evaluate('rsImagen.#Attributes.codigo#')#.dat" 
			output="#toBinary(Evaluate('rsImagen.#Attributes.contenido#'))#">
	<cfif isdefined("rsImagen.#Attributes.tipo_contenido#")>
		<cfset tipo = Evaluate("rsImagen.#Attributes.tipo_contenido#")>
	<cfelse>
		<cfset tipo = "image/*">
	</cfif>
	<cfif isdefined("rsImagen.#Attributes.nombre#")>
		<cfset nombre_arch = Evaluate("rsImagen.#Attributes.nombre#")>
	<cfelse>
		<cfset nombre_arch = Attributes.imgname & ".gif">
	</cfif>
		<img id="#Attributes.imgname#" name="#Attributes.imgname#" src="#Attributes.fileToDownload#?codigo=#Evaluate('rsImagen.#Attributes.codigo#')#&nombre=#nombre_arch#&tipocont=#tipo#" <cfif attributes.width NEQ 0>width="#Attributes.width#"</cfif> <cfif attributes.height NEQ 0>height="#Attributes.height#"</cfif> border="<cfif Attributes.border>1<cfelse>0</cfif>" <cfif Len(Trim(Attributes.alt)) NEQ 0>alt="#Attributes.alt#"</cfif>>
	</cfoutput>
<cfelse>
	<cfexit method="exittag">
</cfif>
