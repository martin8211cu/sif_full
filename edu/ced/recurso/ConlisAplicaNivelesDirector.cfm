<cfinclude template="/edu/Utiles/general.cfm">
<cfif isdefined("Url.Dcodigo") and not isdefined("Form.Dcodigo")>
	<cfparam name="Form.Dcodigo" default="#Url.Dcodigo#">
<cfelse>
	
</cfif>

<cfif isdefined("Form.btnAplicar")>
	 <cfquery name="rsDelete" datasource="#Session.Edu.DSN#">
		delete DirectorNivel 
		where Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Dcodigo#">
		  and Ncodigo in (#form.Cual_Nivel#)  
	</cfquery> 
	<cfif isdefined("Form.Chk")>
		<cfset a=ListToArray(Form.Chk,',')>
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			<cfset Ncodigo = b[1]>
			<cfquery name="ABC_NivelAplica" datasource="#Session.Edu.DSN#">
				insert DirectorNivel (Dcodigo, Ncodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Dcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Ncodigo#">
							)
			</cfquery>
		</cfloop>
	</cfif>	
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<form name="lista" method="post" action="ConlisAplicaNivelesDirector.cfm">
		<tr> 
			<td>
				<input type="hidden" name="Dcodigo" value="<cfif isdefined("Form.Dcodigo")><cfoutput>#Form.Dcodigo#</cfoutput></cfif>">
				<input name="Cual_Nivel" type="hidden" id="Cual_Nivel" value="">
				<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
					<cfset Pagenum_lista = #Form.Pagina#>
				</cfif> 
				<cfset filtro = "">
				 <cfinvoke 
					 component="edu.Componentes.pListas"
					 method="pListaEdu"
					 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="Nivel a, DirectorNivel b, Director d"/>
						<cfinvokeargument name="columnas" value="convert(varchar, b.Dcodigo) as Dcodigo, convert(varchar, a.Ncodigo) as Ncodigo, substring(a.Ndescripcion,1,50) as Ndescripcion, convert(varchar, b.Ncodigo) as checked"/>
						<cfinvokeargument name="desplegar" value="Ndescripcion"/>
						<cfinvokeargument name="etiquetas" value="Descripción del Nivel"/>
						<cfinvokeargument name="formatos" value="S"/>
						<cfinvokeargument name="filtro" value=" a.CEcodigo = #Session.Edu.CEcodigo# and b.Dcodigo = #Form.Dcodigo#  and b.Ncodigo =* a.Ncodigo 
																and d.Dcodigo =* b.Dcodigo order by a.Norden"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<!--- <cfinvokeargument name="irA" value="ConlisAplicaNivelesDirector.cfm"/> --->
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="conexion" value="#Session.Edu.DSN#"/>
						<cfinvokeargument name="showlink" value="false"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="maxrows" value="10"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formName" value="lista"/>
						<cfinvokeargument name="keys" value="Ncodigo "/>
						<cfinvokeargument name="checkedcol" value="checked"/>
						<cfinvokeargument name="botones" value="Aplicar,Cerrar"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
				</cfinvoke>
			</td>
		</tr>
		</form>
 	</table>

 <script language="JavaScript">
	if (document.lista.chk != null) {
		if (document.lista.chk.value != null) {
			if (document.lista.chk.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
				var a = document.lista.chk.value.split("|");
				var Ncodigo = a[0];
				//alert(a);
				document.lista.Cual_Nivel.value += Ncodigo ;
		} else {
			for (var counter = 0; counter < document.lista.chk.length; counter++) {
				var a = document.lista.chk[counter].value.split("|");
				var Ncodigo = a[0];
				//alert(a);
				document.lista.Cual_Nivel.value += Ncodigo + ",";
			}
			if (document.lista.Cual_Nivel.value != "") {
				document.lista.Cual_Nivel.value = document.lista.Cual_Nivel.value.substring(0,document.lista.Cual_Nivel.value.length-1);
			}
		}
	}
	
	function funcCerrar(){
		window.close();
	}
</script>