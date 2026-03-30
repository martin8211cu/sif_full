<cfset modo = "ALTA">
<cfif not isdefined('form.CERRcod') and isdefined('url.CERRcod')>
	<cfset form.CERRcod = url.CERRcod>
</cfif>
<cfif isdefined("form.CERRcod") and len(trim(form.CERRcod))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifcontrol">
		 select  CERRcod, CERRmsg, CERRdes , CERRcor, CERRref
			from CodigoError
		where CERRcod = #form.CERRcod# 
	</cfquery>
	<cfset CERRref = #data.CERRref#>
<cfelse>
	<cfquery name="data" datasource="sifcontrol">
		 select  max(CERRcod)+1 as CERRcod
		  from CodigoError
	</cfquery>
</cfif>
<form style="margin:0;" name="form1" action="ErroresPortal-sql.cfm" method="post">
<cfif modo neq 'ALTA'>
	<cfoutput>
		<!---Codigo--->
		<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
			<tr>
				<td align="left" valign="top">Código: 
					#data.CERRcod#
				</td>
			</tr>
		<!---Error--->	
			<tr>
				<td align="left" valign="top">Error: </td>
			</tr>
			<tr>
				<td nowrap>
				<textarea name="CERRmsg" rows="3"  style="font-family:sans-serif; width:100%;" onfocus="this.select();" readonly="readonly">#trim(data.CERRmsg)#</textarea>
				</td>
			</tr>
		<!---Descripción--->	
			<tr><td align="left" valign="top">
				Descripción:
				</td>
			</tr>
			<tr>
				<td nowrap>
				  <textarea name="CERRdes" rows="5" style="font-family:sans-serif; width:100%; display:block" onfocus="this.select();" readonly="readonly">#data.CERRdes#</textarea>
				</td>
			</tr>
		<!---Solución--->	
			<tr>
				<td align="left" valign="top">Solución: </td>
			</tr>
			<tr>
				<td nowrap>
				  <textarea name="CERRcor" rows="5" style="font-family:sans-serif; width:100%; display:block:" onfocus="this.select();" readonly="readonly">#data.CERRcor#</textarea>
				</td>
			</tr>
		<!---Script--->	
			<tr>
				<td align="left" valign="top">Script: </td>
			</tr>
			<tr>
				<td nowrap>
				<cfset script = fnScript()>
				  <textarea rows="15" style="font-family:'Courier New', Courier, monospace; font-size:10px; width:100%; display:block:" onfocus="this.select();" readonly="readonly">#script#</textarea>
				</td>
			</tr>
		<!--- Portles de Botones --->
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<input name="irGenerarError" value="Ir a generar CF_ErrorCode" type="submit" class="btnNormal">
			</td>
		</tr>
		</table>
	</cfoutput>
	</form>
<cfelse>
	<table>
	<!--- Pagina --->
		<tr>
		  <td align="left"><span class="etiquetaCampo">Fuente:</span></td>
	    </tr>
	    <tr>
			<td align="left">
				<input type="text" name="Fuente" size="40" maxlength="255" onFocus="this.select();">
				<a href="javascript:conlisFiles();" ><img width="16" height="16" src="../../portal/imagenes/foldericon.png" border="0"></a>
				<BR />
				<input type="checkbox" name="chkSubdir" /> Incluir todos los fuentes del Directorio
		     </td>
		</tr>
		<!--- Portles de Botones --->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input name="btnGenerar" value="Generar CF_ErrorCode" type="submit" class="btnNormal">
			</td>
		</tr>
	
	</table>
</cfif>
</form>
<script language="javascript1.2" type="text/javascript">
function conlisFiles(){
		closePopup();
		window.gPopupWindow = window.open('../../portal/catalogos/files.cfm?p='+escape(document.form1.Fuente.value),'_blank',
			'left=50,top=50,width=300,height=400,status=no,toolbar=no,title=no');
		window.onfocus = closePopup;
	}
function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
function conlisFilesSelect(filename){
		document.form1.Fuente.value = filename;
		closePopup();
		window.focus();
		document.form1.Fuente.focus();
	}
</script>

<cffunction name="fnScript">
	<cfset LvarCFerror = structNew()>
	<cfset LvarCFerror.datos = arrayNew(1)>
	<cfset LvarCFerror.datosN = 0>
	<cfset data.CERRmsg = fnEvaluarMSG(data.CERRmsg)>
	<cfif LvarCFerror.datosN GT 0>
		<cfset LvarScript = "<cf_errorCode code = ""#data.CERRcod#""">
		<cfset LvarScript = LvarScript & chr(13) & chr(10) & "              msg  = ""#data.CERRmsg#""">
		<cfloop index="i" from="1" to="#LvarCFerror.datosN#">
			<cfset LvarScript = LvarScript & chr(13) & chr(10) & "              #LvarCFerror.datos[i]# = ""##VALOR_#i###""">
		</cfloop>
		<cfset LvarScript = LvarScript & chr(13) & chr(10)  & ">">
	<cfelse>
		<cfset LvarScript = "<cf_errorCode code = ""#data.CERRcod#"" msg  = ""#data.CERRmsg#"">	">
	</cfif>
	<cfreturn LvarScript>
</cffunction>

<cffunction name="fnEvaluarMSG" access="private" output="yes" returntype="string">
	<cfargument name="MSG" type="string">

	<cfset var LvarMSG = Arguments.MSG>
	<cfif find("@",Arguments.MSG)>
		<cfset LvarMSG = "">
		<cfset LvarPto0 = 0>
		<cfset LvarPto1 = 0>
		<cfset LvarPto2 = 0>
		<cfloop condition="true">
			<cfset LvarPto0 = LvarPto2+1>
			<cfset LvarPto1 = find("@",Arguments.MSG,LvarPto2+1)>
			<cfset LvarPto2 = find("@",Arguments.MSG,LvarPto1+1)>
			<cfset LvarVAR = "">
			<cfif LvarPto1 EQ 0 OR LvarPto2 EQ 0>
				<cfbreak>
			</cfif>
			<cfset LvarMSG = LvarMSG & mid(Arguments.MSG,LvarPto0,LvarPto1-LvarPto0)>
			<cfset LvarVAR = mid(Arguments.MSG,LvarPto1+1,LvarPto2-LvarPto1-1)>
			<cfset LvarPto3 = find("'",LvarVAR)>
			<cfif ( len(LvarVAR)-len(replace(LvarVAR,"'","","ALL")) ) mod 2 NEQ 0>
		<cfset LvarXXX = 1>
				<cfset LvarPto2 = find("@",Arguments.MSG,LvarPto2+1)>
				<cfif LvarPto2 EQ 0>
					<cfbreak>
				</cfif>
				<cfset LvarPto2 = find("@",Arguments.MSG,LvarPto2+1)>
				<cfif LvarPto2 EQ 0>
					<cfbreak>
				</cfif>
				<cfset LvarVAR = mid(Arguments.MSG,LvarPto1+1,LvarPto2-LvarPto1-1)>
			</cfif>
			<cfif trim(LvarVAR) EQ "">
				<cfset LvarMSG = LvarMSG & "####">
			<cfelse>
				<cfset LvarCFerror.datosN ++>
				<cfset LvarCFerror.datos[LvarCFerror.datosN] = LvarVAR>
				<cfset LvarMSG = LvarMSG & "@errorDat_#LvarCFerror.datosN#@">
			</cfif>
		</cfloop>
		<cfset LvarMSG = LvarMSG & mid(Arguments.MSG,LvarPto0,len(Arguments.MSG))>
		<cfset LvarMSG = replace(LvarMSG, '""', "'", "ALL")>
		<cfset LvarMSG = replace(LvarMSG, '"', "'", "ALL")>
	</cfif>
	<cfreturn LvarMSG>
</cffunction>
