<cfset debug = false>

<cfquery name="rsMenuYo" datasource="#Session.DSN#" >
	select b.METEetiq, b.METEid, b.MESid
	from METipoEntidad a, MEServicioEntidad b, MEServicio c, MEServicioEmpresa d
	where a.METEmenu = 1
	  and a.METEusuario = 1
	  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.METEid = b.METEid
	  and b.MESid = c.MESid
	  and c.MESid = d.MESid
	  order by b.METEorden
</cfquery>

<cfquery name="rsEmpresas" datasource="asp">
	select Ecodigo, Ereferencia as consecutivo, Enombre as nombre_comercial
	from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<cfset url.METEid = rsMenuYo.METEid>
<cfif IsDefined("session.MEEid") and Len(session.MEEid) NEQ 0 and session.MEEid NEQ 0>
	<cfset url.MEEid = session.MEEid>
<cfelse>
	<cfset url.MEEid = "">
</cfif>
<cfset form.MEEid = url.MEEid>
<cfset form.METEid = url.METEid>

<cfquery name="rsMETEinfo" datasource="#Session.DSN#">
	select METEid, METEdesc
	from METipoEntidad
	where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.METEid#">
</cfquery>

<cf_template>
<cf_templatearea name="title">
	Mis Datos Personales
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">

	<cfinclude template="pNavegacion.cfm">
	
	<!--- Definición del MODO por Defecto --->
	<cfif len(trim(url.MEEid))>
		<cfset MODO = "CAMBIO">
	<cfelse>
		<cfset MODO = "ALTA">
	</cfif>
	
	<script language="javascript1.4" type="text/javascript"  src="../../sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
		<!--
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("../../sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		
		function guardar(){
			if (objForm.validate() && finalizar()){
				document.form1.submit();
			}
		}
		
		function lineBlur(obj,m,n){
			n++;
			if (obj.value != "") {
				var rowobj = document.all ? document.all["row_" + m + '_' + n] : document.getElementById("row_" + m + '_' + n);
				if (rowobj) {
					rowobj.style.display = "inline";
				}
			}
		}
		
		//función para mostrar la foto
		function frameChangeImg(frame,imgObj) {
			if (imgObj.name=='MEEimagen'){
			<cfif MODO EQ 'CAMBIO'>
				var dv1_ = document.getElementById(eval("'dv1_"+frame+"'"));
				var dv2_ = document.getElementById(eval("'dv2_"+frame+"'"));
				dv1_.style.display = '';
				dv2_.style.display = 'none';
			</cfif>
			frame = "'" + frame + "'";
			document.all[eval(frame)].src="showImg.cfm?img=" + imgObj.value;
			}	
		}
		<cfif MODO eq 'CAMBIO'>
		//función para mostrar la foto grande
		function showPicture2() {
			var width = 600;
			var height = 500;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			var nuevo = window.open('showImg.cfm?MEEid=#url.MEEid#','FotoNatural','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
		}
		</cfif>
		
		function doConlisEntidad(ContName,METEid,MEEid) {
			var width = 600;
			var height = 500;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			
			<cfoutput>
				var nuevo = window.open('gen-conlisEntidad.cfm?ContName='+ContName+'&METEid='+METEid+'&PMEEid='+MEEid,'ListaEntidades','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			
			nuevo.focus();
		}
		
		function ResetEntidad(campos,tipos) {
			var arrcampos = campos.split(',');
			var arrtipos = tipos.split(',');
			for (i = 0; i < arrcampos.length; i++){
				if (arrtipos[i].toUpperCase()!='BUTTON')
					eval("document.form1."+arrcampos[i]+".value=''");
			}
		}
		
		function MM_swapImgRestore() { //v3.0
		  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
		}
		
		function MM_preloadImages() { //v3.0
		  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
			var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
			if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
		}
		
		function MM_findObj(n, d) { //v4.01
		  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
			d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		  if(!x && d.getElementById) x=d.getElementById(n); return x;
		}
		
		function MM_swapImage() { //v3.0
		  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
		}
		//-->
	</script>
	
	<!--- Todo lo que este en estos arreglos será tomado en cuenta para las validaciones --->
	<cfset Form.ArrayValidateNames = ArrayNew(1)>
	<cfset Form.ArrayValidateDescs = ArrayNew(1)>
	<cfset Form.ArrayValidateTypes = ArrayNew(1)>
	<cfset Form.ArrayValidateRequired = ArrayNew(1)>	
	
    <form action="%7Emicuenta-sql.cfm" method="post" name="form1" id="form1" enctype="multipart/form-data" style="margin:0">
	<table width="100%"  cellpadding="0" cellspacing="0" border="0">
		<cfif IsDefined("session.Usucodigo") and Len(session.Usucodigo) NEQ 0 and session.Usucodigo NEQ 0 >
			<cfquery datasource="sdc" name="userdata">
				select * from Usuario
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
			</cfquery>
		</cfif>
		<cfif MODO NEQ 'ALTA'>
			<tr class="itemtit"> 
				<td ><font size="2"><b>Actualizar informaci&oacute;n </b></font></td>
			</tr>
			<tr> 
				<td>
					<br>
					<p>
						En este &aacute;rea podr&aacute; modificar la informaci&oacute;n 
						relativa a su cuenta. Al mantener esta informaci&oacute;n actualizada 
						le daremos siempre un mejor servicio.<br> 
					</p>
					<br>
				</td>
			</tr>
		<cfelse>
			<tr class="itemtit"> 
			  <td  ><font size="2"><b>Registro de Usuario</b></font></td>
			</tr>
			<tr> 
			  <td>
			  	<br>
				<p>
					Bienvenido al Registro de Usuarios de nuestro Portal, gracias 
					por preferirnos.<br>
					Por favor, complete este formulario para Subscribirse como un nuevo 
					Usuario, y así aprovechar todos los servicios que le ofrecemos.
				</p>
				<br> 
				<br>
			  </td>
			</tr>
		</cfif>
	<tr>
	<tr>
	<td>
		<table border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td valign="middle" nowrap><strong>Empresa (*):</strong>&nbsp;</td>
			<td valign="middle" nowrap>
				<select name="Empresa" >
					<cfoutput query="rsEmpresas">
						<option value="#Ecodigo#|#consecutivo#"
							<cfif session.ecodigosdc eq ecodigo
							and session.ecodigo eq consecutivo>
								selected
							</cfif>
						>#nombre_comercial#</option>
					</cfoutput>
				</select>
				<cfset ArrayAppend(Form.ArrayValidateDescs,'Empresa')>
				<cfset ArrayAppend(Form.ArrayValidateNames,'Empresa')>
				<cfset ArrayAppend(Form.ArrayValidateTypes,'SEL')>
				<cfset ArrayAppend(Form.ArrayValidateRequired,'R')>
			</td>
		  </tr>
		</table>
	</td>
	</tr>
	<td>
		<cfinclude template="/aspAdmin/cuentas/autoregistro.cfm">
		<cfset ArrayAppend(Form.ArrayValidateDescs,'Email')>
		<cfset ArrayAppend(Form.ArrayValidateNames,'Pemail1')>
		<cfset ArrayAppend(Form.ArrayValidateTypes,'Email')>
		<cfset ArrayAppend(Form.ArrayValidateRequired,'R')>
		<cfset ArrayAppend(Form.ArrayValidateDescs,'Confirmar de Email')>
		<cfset ArrayAppend(Form.ArrayValidateNames,'Pemail1b')>
		<cfset ArrayAppend(Form.ArrayValidateTypes,'Email')>
		<cfset ArrayAppend(Form.ArrayValidateRequired,'R')>
		<cfset ArrayAppend(Form.ArrayValidateDescs,'Nombre')>
		<cfset ArrayAppend(Form.ArrayValidateNames,'Pnombre')>
		<cfset ArrayAppend(Form.ArrayValidateTypes,'String')>
		<cfset ArrayAppend(Form.ArrayValidateRequired,'R')>
		<cfset ArrayAppend(Form.ArrayValidateDescs,'Identificación')>
		<cfset ArrayAppend(Form.ArrayValidateNames,'Pid')>
		<cfset ArrayAppend(Form.ArrayValidateTypes,'String')>
		<cfset ArrayAppend(Form.ArrayValidateRequired,'R')>
	</td>
	</tr>

<!---********************************************************************************************************************************************
	**********************************************************          *************************************************************************
	********************************************************* ENCABEZADO *******************************************************************
	**********************************************************               ********************************************************************
	*********************************************************************************************************************************************--->


	<tr>
	<td>

	<cfoutput>

	<input type="hidden" name="METEid" value="#url.METEid#">
	<input type="hidden" name="MEEid" value="#url.MEEid#">
	
	<!--- Datos Principales de la Entidad --->
	<cfset Encabezado = true>
	<cfset RequerirLinea = true>
	<cfset ContName = ''>
	<!--- Consulta METipoEntidad si es Encabezado para pintar campos definidos --->
	<cfquery name="rsMETipoEntidad" datasource="#Session.DSN#">
		select METEident, METEemail, METEimagen, METEtext, METEetiqident, METEetiqemail, METEetiqimagen, METEetiqtext, METEetiqnom
		from METipoEntidad
		where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.METEid#">
	</cfquery>
	<!--- Consulta METECaracteristica para pintar campos de las caracteristicas --->
	<cfquery name="rsMETECaracteristica" datasource="#Session.DSN#">
		select convert(varchar,METEid) as METEid,
			convert(varchar,METECid) as METECid,
			METECdescripcion,
			METECcantidad,
			METECvalor,
			METECfecha,
			METECtexto,
			METECbit,
			METECdesplegar,
			METEClista,
			METECrequerido,
			METEfila, 
			METEcol
		from METECaracteristica
		where METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.METEid#">
		order by METEfila, METEcol
	</cfquery>	
	<!--- Consulta MEVCaracteristica para los valores de los combos de las caracteristicas con valores predefinidos --->
	<cfquery name="rsValoresCombos" datasource="#Session.DSN#">
		select convert(varchar,a.MEVCid) as value, 
			convert(varchar,a.METECid) as id,
			a.MEVCdescripcion as descripcion
		from MEVCaracteristica a, METECaracteristica b
		where b.METEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.METEid#">
		and a.METECid = b.METECid
	</cfquery>

	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
	  <tr><td class="itemtit"><strong>DATOS ADICIONALES</strong></td></tr>
    </table>

	<cfinclude template="gen-edit-contents.cfm">

	<cfif rsMETipoEntidad.METEtext>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="right">
			  #rsMETipoEntidad.METEetiqtext#
			</td>
			<td>
				<textarea name="MEEdescripcion" cols="60" rows="3" style=" font-family:Arial, Helvetica, sans-serif; font-size:12px"><cfif modo neq 'ALTA'>#rsMEEntidad.MEEdescripcion#</cfif></textarea>
			</td>
		  </tr>
		</table>
	</cfif>
	
	</cfoutput>
	<p>
	<cfif Len(url.MEEid) EQ 0>
	  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="107" height="18">
        <param name="BGCOLOR" value="">
        <param name="movie" value="images/afiliar.swf">
        <param name="quality" value="high">
        <embed src="images/afiliar.swf" width="107" height="18" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" ></embed>
      </object>
	<cfelse>
	  <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="107" height="18">
        <param name="BGCOLOR" value="">
        <param name="movie" value="images/modificar.swf">
        <param name="quality" value="high">
        <embed src="images/modificar.swf" width="107" height="18" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" ></embed>
      </object>
	</cfif>
	</p>
	</form>
	</td>
	</tr>

	</table>
	<!--- Validaciones QForms ** ** Estas validaciones no están en el pForm, porque el pForm se llama n veces,
			para pintar por separado varias secciones de esta página que forman parte del mismo Form. ** ** --->
	<script language="javascript1.4" type="text/javascript">
		//Validaciones del Encabezado Registro de Nomina
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		//Validaciones Agregadas a Qforms
		function _Field_isAlfaNumerico()
		{
			var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?@";
			var tmp="";
			var string = this.value;
			var lc=string.toLowerCase();
			for(var i=0;i<string.length;i++) {
				if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
			}
			if (tmp.length!=this.value.length)
			{
				this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
			}
		}
		function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
		var high=_param(arguments[1], 9999999, "number");
		var iValue=parseInt(qf(this.value));
		if(isNaN(iValue))iValue=0;
		if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
		}}
		function _Field_isFecha(){
			fechaBlur(this.obj);
			if (this.obj.value.length!=10)
				this.error = "El campo " + this.description + " debe contener una fecha válida.";
		}
		function _ConfirmarEmail(){
			if (this.getValue()!=objForm.Pemail1.getValue()){
				this.error = "Los campos Email y Confirmar Email deben ser iguales.";
			}
		}

		_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
		_addValidator("isRango", _Field_isRango);
		_addValidator("isFecha", _Field_isFecha);
		_addValidator("isConfirmarEmail", _ConfirmarEmail);
		//Pone las validaciones a los campos
		<cfloop from="1" to="#ArrayLen(Form.ArrayValidateTypes)#" index="i">
		  <cfoutput>
		  	//#Form.ArrayValidateRequired[i]#
			<cfif listFindNoCase('TRUE,S,R,YES',UCase(Trim(Form.ArrayValidateRequired[i])))>
				objForm.#Trim(Form.ArrayValidateNames[i])#.required = true;
			</cfif>
			<cfif not listFindNoCase('OBJECT',UCase(Trim(Form.ArrayValidateTypes[i])))>
				objForm.#Trim(Form.ArrayValidateNames[i])#.validate = false;
				objForm.#Trim(Form.ArrayValidateNames[i])#.description = "#Trim(Form.ArrayValidateDescs[i])#";
			</cfif>
			<cfif listFindNoCase('Integer,Int,I',UCase(Trim(Form.ArrayValidateTypes[i])))>
				objForm.#Trim(Form.ArrayValidateNames[i])#.validateNumeric('El valor debe ser numérico para ' + objForm.#Trim(Form.ArrayValidateNames[i])#.description + '.');
			<cfelseif listFindNoCase('Numeric,N,Money,M',UCase(Trim(Form.ArrayValidateTypes[i])))>
				objForm.#Trim(Form.ArrayValidateNames[i])#.validateRango('0','999999999');
			<cfelseif Trim(Form.ArrayValidateTypes[i]) eq 'EMAIL'>
				objForm.#Trim(Form.ArrayValidateNames[i])#.validateEmail("Correo Inválido. El valor para " + objForm.#Trim(Form.ArrayValidateNames[i])#.description + " debe ser un correo electrónico válido.");
			<cfelseif listFindNoCase('S,String,Varchar',UCase(Trim(Form.ArrayValidateTypes[i])))>
				objForm.#Trim(Form.ArrayValidateNames[i])#.validateAlfaNumerico();
			<cfelseif listFindNoCase('DATE,D',UCase(Trim(Form.ArrayValidateTypes[i])))>
				objForm.#Trim(Form.ArrayValidateNames[i])#.validateFecha();
			</cfif>
		  </cfoutput>
		</cfloop>
		
		objForm.Pemail1b.validateConfirmarEmail();
		
		MM_preloadImages('images/editar-roll.gif');
		MM_preloadImages('images/find-roll.gif');
		
		function quitarFormatoCurrency(){
			<cfoutput>
				<cfloop from="1" to="#Arraylen(Form.ArrayValidateNames)#" index="i">
					<cfif listFindNoCase('Numeric,N,Integer,Int,I,Money,M',UCase(Trim(Form.ArrayValidateTypes[i])))>
						document.form1.#Trim(Form.ArrayValidateNames[i])#.value = qf(document.form1.#Trim(Form.ArrayValidateNames[i])#);
					</cfif>
				</cfloop>
			</cfoutput>
		}
		
		function finalizar(){
			quitarFormatoCurrency();
			return true;
		}
	</script>
</cf_templatearea>
</cf_template>
