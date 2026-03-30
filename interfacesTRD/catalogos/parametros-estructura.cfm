<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Par&aacute;metros de Interfaces
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
	  <cf_web_portlet titulo="Consulta de la Estructura de las Tablas de Entrada y Salida para la Interfaz #form.NumeroInterfaz#">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="parametros-motor.cfm">
			
			<cfquery name="rsSQL" datasource="sifinterfaces">
				select Descripcion from Interfaz
				 where NumeroInterfaz = #form.NumeroInterfaz#
			</cfquery>
			<form action="parametros.cfm" method="post" name="sql">
				<cfoutput><strong>INTERFAZ: #form.NumeroInterfaz# = #rsSQL.Descripcion#</strong><BR><BR></cfoutput>

				<cfset GvarIndex = 0>
					<cftry>
					
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from IE#form.NumeroInterfaz# where ID = 0
						</cfquery>
						<cfoutput><div style="text-align:center;"><strong>DATOS DE ENTRADA</strong><BR><BR></div></cfoutput>

						<cfset sbMostrar("IE#form.NumeroInterfaz#",rsSQL)>
						<cfset sbMostrar("ID#form.NumeroInterfaz#",rsSQL)>
						<cfset sbMostrar("IS#form.NumeroInterfaz#",rsSQL)>
					<cfcatch type="database">
					</cfcatch>
					</cftry>
				
					<cftry>
						<cfquery name="rsSQL" datasource="sifinterfaces">
							select * from OE#form.NumeroInterfaz# where ID = 0
						</cfquery>
						<cfoutput><div style="text-align:center;"><strong>DATOS DE SALIDA</strong><BR><BR></div></cfoutput>

						<cfset sbMostrar("OE#form.NumeroInterfaz#",rsSQL)>
						<cfset sbMostrar("OD#form.NumeroInterfaz#",rsSQL)>
						<cfset sbMostrar("OS#form.NumeroInterfaz#",rsSQL)>
					<cfcatch type="database">
					</cfcatch>
					</cftry>
				
				<input type="hidden" name="id" value="#form.id#">
				<input type="hidden" name="ni" value="#form.NumeroInterfaz#">
				<input type="hidden" name="sc" value="#form.sc#">
				<input type="hidden" name="msg" value="#form.msg#">
				<input type="hidden" name="cmd" value="V">
				<div style="text-align:center;">
					<input type="submit" name="btnRegresar" value="Regresar">
				</div>
			</form>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>

<cffunction name="sbMostrar" output="true">
	<cfargument name="Tabla" type="string" required="yes">
	<cfargument name="rsSQL" type="query" required="yes">

	<cfset LvarDigitos = "12345678901234567890123456789012345678901234567890">
	<cf_dbstruct name="#Tabla#" datasource="sifinterfaces">
	<cfif rsStruct.recordCount GT 0>
		<cf_web_portlet titulo="TABLA: #Arguments.Tabla#" width="95%">
			<cfset LvarCampos = rsSQL.getColumnnames()>
			<strong>FORMATO DEL ARCHIVO:</strong>
			<table>
				<tr>
					<td><strong>Campo</strong></td>
					<td><strong>Tipo Dato</strong></td>
					<td><strong>Obligatorio</strong></td>
					<td><strong>Valores Permitidos en XML</strong></td>
				</tr>
			<cfloop query="rsStruct">
				<tr>
				<cfset LvarCampo 		= rsStruct.name>
				<cfset LvarCF_sql_type 	= mid(rsStruct.cf_sql_type,8,100)>
				<cfset LvarCF_type 		= rsStruct.cf_type>
				<cfif rsStruct.dec EQ 0 or rsStruct.dec EQ "">
					<cfset LvarFormato = "#LvarCF_sql_type#(#rsStruct.len#)">
				<cfelseif rsStruct.ent eq 0>
					<cfset LvarFormato = "#LvarCF_sql_type#(#rsStruct.dec#)">
				<cfelse>
					<cfset LvarFormato = "#LvarCF_sql_type#(#rsStruct.len#,#rsStruct.dec#)">
				</cfif>
				<cfif LvarCF_Type EQ "B">
					<cfset LvarDatos = "Binario codificado en Base64">
				<cfelseif LvarCF_Type EQ "D">
					<cfset LvarFormato 	= "DateTime">
					<cfset LvarDatos 	= "Fechas de la forma YYYY-MM-DD HH:MM:SS">
				<cfelseif LvarCF_Type EQ "N">
					<cfif LvarCF_sql_type EQ "bit">
						<cfset LvarFormato 	= "bit">
						<cfset LvarDatos	= "sólo valores 0 ó 1">
					<cfelseif rsStruct.db_type EQ "tinyint">
						<cfset LvarFormato = "tinyint">
						<cfset LvarDatos = "sólo valores del 0 a 255">
					<cfelseif rsStruct.dec EQ 0>
						<cfset LvarXMLencoded = "Número sin decimales codificado en XML:\n     Sólo permite dígitos numéricos (0 a 9) y signo negativo a la izquierda (-)">
						<cfset LvarDatos = "Número sin decimales codificado en XML <a href='javascript:alert(""#LvarXMLencoded#"");'><font color='##FF0000'>(?)</font></a>">
					<cfelse>
						<cfset LvarXMLencoded = "Número con decimales codificado en XML:\n     Sólo permite dígitos numéricos (0 a 9), signo negativo a la izquierda (-) y punto decimal (.)">
						<cfset LvarDatos = "Número con decimales codificado en XML <a href='javascript:alert(""#LvarXMLencoded#"");'><font color='##FF0000'>(?)</font></a>">
					</cfif>
				<cfelseif LvarCF_Type EQ "S">
					<cfset LvarXMLencoded = "String codificado en XML:\n\     Permite cualquier caracter: entre chr(32) y chr(127), excepto: > < "" + String.fromCharCode(34) + "" "" + String.fromCharCode(39) + "" &\n\t\tSustituir:\t\t\t\tPor:\n\tchr(13)+chr(10) o chr(13)\t\tchr(10)\n\tchr(0) a chr(31) y chr(128) a chr(255)\t&\##xFF; (donde FF es cod.hex. del caracter)\n\t\t> < "" + String.fromCharCode(34) + "" "" + String.fromCharCode(39) + "" &\t\t\t&\gt; &\lt; &\apos; &\quot; &\amp;">
					<cfset LvarDatos = "String codificado en XML <a href='javascript:alert(""#LvarXMLencoded#"");'><font color='##FF0000'>(?)</font></a>">
				</cfif>
					<td>#LvarCampo#</td>
					<td>#LvarFormato#</td>
				<cfif rsStruct.mandatory EQ 1>
					<td align="center">S</td>
				<cfelse>
					<td align="center">N</td>
				</cfif>
					<td>#LvarDatos#</td>
				</tr>
			</cfloop>
			</table>


			<BR>
			<cfset LvarPrueba = 'Prueba = "A & B > C"'>
			<strong>EJEMPLO XML:</strong>&nbsp;&nbsp;&nbsp;(Valor ejemplo para String y Binario: <span style="background-color:##CCCCCC; color:##6600CC;">#LvarPrueba#</span>   )

			<textarea rows="#rsStruct.recordCount + 7#" cols="130">
<cfsetting enablecfoutputonly="yes">
			<cfoutput><resultset>
</cfoutput>
			<cfoutput>    <row>
</cfoutput>
			<cfloop query="rsStruct">
				<cfset LvarCampo 		= rsStruct.name>
				<cfset LvarCF_sql_type 	= mid(rsStruct.cf_sql_type,8,100)>
				<cfset LvarCF_type 		= rsStruct.cf_type>
				<cfif LvarCF_Type EQ "B">
					<cfset LvarValor = "#toBase64(mid(LvarPrueba,1,rsStruct.len))#">
				<cfelseif LvarCF_Type EQ "D">
					<cfset LvarValor = "#dateFormat(now(),"YYYY-MM-DD")# #timeFormat(now(),"HH:MM:SS")#">
				<cfelseif LvarCF_Type EQ "N">
					<cfif LvarCF_sql_type EQ "bit">
						<cfset LvarValor = "1">
					<cfelseif rsStruct.db_type EQ "tinyint">
						<cfset LvarValor = "255">
					<cfelseif rsStruct.dec EQ 0>
						<cfset LvarValor = "-#mid(LvarDigitos,1,rsStruct.len)#">
					<cfelseif rsStruct.ent EQ 0>
						<cfset LvarValor = "-0.#mid(LvarDigitos,1,rsStruct.dec)#">
					<cfelse>
						<cfset LvarValor = "-#mid(LvarDigitos,1,rsStruct.ent)#.#mid(LvarDigitos,rsStruct.ent+1,rsStruct.dec)#">
					</cfif>
				<cfelseif LvarCF_Type EQ "S">
					<cfset LvarValor = XMLformat(XMLformat(mid(LvarPrueba,1,rsStruct.len)))>
				</cfif>
			<cfoutput>        <#LvarCampo#>#LvarValor#</#LvarCampo#>
</cfoutput>
			</cfloop>
			<cfoutput>    </row>
</cfoutput>
			<cfoutput>    <row>
</cfoutput>
			<cfoutput>        ...
</cfoutput>
			<cfoutput>    </row>
</cfoutput>
			<cfoutput></resultset></textarea>
</cfoutput>
			<cfsetting enablecfoutputonly="no">
		</cf_web_portlet>
		<BR>
 		</cfif>
</cffunction>