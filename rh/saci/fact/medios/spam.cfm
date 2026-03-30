<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="311" returnvariable="popServer"/>
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="312" returnvariable="popUsername"/>
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="313" returnvariable="popPassword"/>

<cfpop server="#popServer#" username="#popUsername#" password="#popPassword#" name="correo" action="getheaderonly"/>

<cfparam name="url.filtro_From" default="">
<cfparam name="url.filtro_To" default="">
<cfparam name="url.filtro_Subject" default="">
<cfparam name="url.filtro_Date" default="">

<cfif Len(url.filtro_From) Or Len(url.filtro_To) Or Len(url.filtro_Subject) Or Len(url.filtro_Date)>
	<cfquery dbtype="query" name="correo">
		select * from correo
		where 1 = 1
		<cfif Len(url.filtro_From)>
			and lower([from]) like <cfqueryparam cfsqltype="varchar" value="%# LCase( url.filtro_From )#%">
		</cfif>
		<cfif Len(url.filtro_To)>
			and lower([to]) like <cfqueryparam cfsqltype="varchar" value="%# LCase( url.filtro_To )#%">
		</cfif>
		<cfif Len(url.filtro_Subject)>
			and lower([subject]) like <cfqueryparam cfsqltype="varchar" value="%# LCase( url.filtro_Subject )#%">
		</cfif>
		<cfif Len(url.filtro_Date)>
			and lower([date]) like <cfqueryparam cfsqltype="varchar" value="%# LCase( url.filtro_Date )#%">
		</cfif>
	</cfquery>
</cfif>


<cfset lista_PageSize = 20>
<cfparam name="url.PageNum_lista" default="1" type="numeric">
<cfif url.PageNum_lista GT Ceiling (correo.RecordCount / lista_PageSize)>
	<cfset url.PageNum_lista = Ceiling (correo.RecordCount / lista_PageSize)>
<cfelse>
	<cfset url.PageNum_lista = Int(url.PageNum_lista)>
</cfif>
<cfset lista_StartRow = (url.PageNum_lista - 1) * lista_PageSize + 1>
<cfset lista_EndRow = url.PageNum_lista * lista_PageSize>
<cfif lista_EndRow GT correo.RecordCount>
	<cfset lista_EndRow = correo.RecordCount>
</cfif>
<cfif lista_StartRow LT 1>
	<cfset lista_StartRow = 1>
</cfif>

<cfoutput>
<form name="lista" action="spam-delete.cfm" method="post">
<input type="hidden" name="tab" value="spam">
<input type="hidden" name="PageNum_lista" value="#PageNum_lista#">
<table width="950" border="0" cellpadding="2" cellspacing="0">
    
    <tr>
      <td width="20">&nbsp;</td>
      <td width="200">&nbsp;</td>
      <td width="170">&nbsp;</td>
      <td width="300">&nbsp;</td>
      <td width="240">&nbsp;</td>
    </tr>
    <tr class="tituloListas" >
      <td height="17" align="left">&nbsp;</td>
      <td align="left" valign="bottom"><strong >De</strong> </td>
      <td align="left" valign="bottom"><strong >Para</strong> </td>
      <td align="left" valign="bottom"><strong >Asunto</strong> </td>
      <td align="left" valign="bottom"><strong >Fecha</strong> </td>
    </tr>
    <tr class="tituloListas" >
      <td height="17" align="left" valign="top"><input type="checkbox" name="chkAllItems" value="1" onclick="javascript: funcFiltroChkAlllista(this);" style="border:none">      </td>
      <td align="left" valign="top"><input type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
								onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
								name="filtro_From" value="# HTMLEditFormat( url.filtro_From ) #"></td>
      <td align="left" valign="top"><input type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
								onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
								name="filtro_To" value="# HTMLEditFormat( url.filtro_To ) #"></td>
      <td align="left" valign="top"><input type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
								onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
								name="filtro_Subject" value="# HTMLEditFormat( url.filtro_Subject ) #"></td>
      <td align="left" valign="top"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="100%" align="left"><input type="text" size="6" maxlength="30" style="width:100%" onfocus="this.select()" 
								onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
								name="filtro_Date" value="# HTMLEditFormat( url.filtro_Date ) #"></td>
			</tr><!--- x ---><tr>
            <td><table cellspacing='1' cellpadding='0' >
                <tr>
                  <td><input type="button" value="Filtrar" class="btnFiltrar" onclick="return filtrarlista();"></td>
                  <td><input type="submit" name="btnBorrar" value="Borrar" onclick="return funcBorrar();">                  </td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
	<cfloop query="correo" startrow="#lista_StartRow#" endrow="#lista_EndRow#">
		<cfset cl = IIf(CurrentRow Mod 2, "'listaPar'", "'listaNon'")>
    <tr class="#cl#" onmouseover="this.className='#cl#Sel';" onmouseout="this.className='#cl#';" style="cursor:pointer">
      <td valign="top"><input type="checkbox" name="messagenumber" value="#correo.messagenumber#" onclick="javascript: funcFiltroChkThislista(this); void(0);"   style="border:none;">	  </td>
      <td valign="top" onclick="DetalleCorreoSpam('# correo.messagenumber#')"><div style="width:95%;overflow:hidden;white-space:nowrap;" title="#HTMLEditFormat(correo.from) #">#HTMLEditFormat(correo.from) #</div></td>
      <td valign="top" onclick="DetalleCorreoSpam('# correo.messagenumber#')"><div style="width:95%;overflow:hidden;white-space:nowrap;" title="#HTMLEditFormat(correo.to) #">#HTMLEditFormat(correo.to) #</div></td>
      <td valign="top" onclick="DetalleCorreoSpam('# correo.messagenumber#')"><div style="width:95%;overflow:hidden;white-space:nowrap;" title="#HTMLEditFormat(correo.subject) #">#HTMLEditFormat(correo.subject) #</div></td>
      <td valign="top" onclick="DetalleCorreoSpam('# correo.messagenumber#')"><div style="width:100%;overflow:hidden;white-space:nowrap;">#HTMLEditFormat(correo.date) #</div></td>
    </tr>
	</cfloop>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="5"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="99%" align="center">
			<cfset PageUrl = "index.cfm?tab=spam&filtro_From=#URLEncodedFormat( url.filtro_From ) #&filtro_To=#URLEncodedFormat( url.filtro_To ) #&filtro_Subject=#URLEncodedFormat( url.filtro_Subject ) #&filtro_Date=#URLEncodedFormat( url.filtro_Date ) #">
			<cfif url.PageNum_lista GT 1>
			<a href="# HTMLEditFormat( PageURL ) #&amp;PageNum_lista=1" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border=0></a>
			 <a href="# HTMLEditFormat( PageURL ) #&amp;PageNum_lista=#url.PageNum_lista-1#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border=0></a>
			 </cfif>
			 <cfif url.PageNum_lista LT Ceiling(correo.RecordCount / lista_PageSize)>
			 <a href="# HTMLEditFormat( PageURL ) #&amp;PageNum_lista=#url.PageNum_lista+1#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border=0></a>
			 <a href="# HTMLEditFormat( PageURL ) #&amp;PageNum_lista=#Ceiling(correo.RecordCount / lista_PageSize)#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border=0></a>
			 </cfif></td>
            <td nowrap align="right" width="1%" >
			<cfif correo.RecordCount>
			Vista Actual #lista_StartRow# - #lista_EndRow# de #correo.RecordCount#
			<cfelse>
			No hay correo sin procesar	
			</cfif></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
</cfoutput>
<script type="text/javascript">
<!--
	function chks(){
		var s = '', f = document.lista;
		if (f.messagenumber.length) {
			for(var i=0; i < f.messagenumber.length; i++)
				if (f.messagenumber[i].checked) {
					if (s.length) s += ',';
					s += escape(f.messagenumber[i].value);
				}
		} else if (f.messagenumber.checked) {
			s = 'messagenumber=' + escape(f.messagenumber.value);
		}
		return s;
	}
	function funcBorrar() {
		var ch = chks();
		if (!ch.length) {
			alert('Seleccione los correos que desea borrar.');
			return false;
		}
	}
	function DetalleCorreoSpam(messagenumber) {
		window.open('<cfoutput># JSStringFormat( PageUrl ) #&PageNum_lista=#url.PageNum_lista#</cfoutput>&messagenumber=' + escape(messagenumber), '_self');
	}
	
	
		
	function funcFiltroChkAlllista(c){
		if (document.lista.messagenumber) {
			if (document.lista.messagenumber.value) {
				if (!document.lista.messagenumber.disabled) { 
					document.lista.messagenumber.checked = c.checked;
				}
			} else {
				for (var counter = 0; counter < document.lista.messagenumber.length; counter++) {
					if (!document.lista.messagenumber[counter].disabled) {
						document.lista.messagenumber[counter].checked = c.checked;
					}
				}
			}
		}
	}
	function funcFiltroChkThislista(c){
		checked = true;
		if (document.lista.messagenumber) {
			if (document.lista.messagenumber.value) {
				if (!document.lista.messagenumber.disabled) { 
					if (!document.lista.messagenumber.checked) {
						checked = false;
					}									
				}
			} else {
				for (var counter = 0; counter < document.lista.messagenumber.length; counter++) {
					if (!document.lista.messagenumber[counter].disabled) {
						if (!document.lista.messagenumber[counter].checked) {
							checked = false;
						}	
					}
				}
			}
		}
		document.lista.chkAllItems.checked = checked;
	}

	function filtrarlista(){
		document.lista.PageNum_lista.value = 1;
		document.lista.method = 'get';
		document.lista.action = 'index.cfm'; 
		document.lista.submit();
		return false;
	}
//	-->
</script>
