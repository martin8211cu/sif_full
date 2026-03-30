<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>

<cfif dmodo NEQ "ALTA">
	<cfquery name="rsLinea" datasource="#Session.DSN#">
		select 	a.DClinea, 
				a.ECid, 
				#LvarOBJ_PrecioU.enSQL_AS("a.DCpreciou")#, 
				a.DCgarantia, 
				a.ts_rversion,
				coalesce(a.Aid,-1) as Aid, 
				coalesce(a.Cid,-1) as Cid,	
				case when c.Cid is null then d.Adescripcion
					 when a.Aid is null then c.Cdescripcion
					 else '' end as descripcion					
		from DContratosCM a
		
		inner join EContratosCM b
		on a.Ecodigo = b.Ecodigo
		   and a.ECid = b.ECid
		
		left outer join Conceptos c
		on a.Ecodigo = c.Ecodigo 
		   and a.Cid = c.Cid					
		
		left outer join Articulos d
		on a.Ecodigo = d.Ecodigo 
		   and a.Aid = d.Aid
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		and a.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
		order by a.DClinea
	</cfquery>
	
	<cfquery name="rsArticulos" datasource="#session.DSN#">
		select Aid, Acodigo, Adescripcion
		from Articulos
		where Aid = <cfif len(trim(rsLinea.Aid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#"><cfelse>-1</cfif>
	</cfquery>
	
	<cfquery name="rsConceptos" datasource="#session.DSN#">
		select Cid, Ccodigo, Cdescripcion
		from Conceptos
		where Cid = <cfif len(trim(rsLinea.Cid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Cid#"><cfelse>-1</cfif>
	</cfquery>

</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" >
var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function limpiarDetalle() {
		//document.form1.descripcion.value="";
		document.form1.Aid.value="";
		document.form1.Cid.value="";			
	}

	function cambiarDetalle(){
		if(document.form1.Item.value=="A"){
			document.getElementById("larticulo").style.display = '';
			document.getElementById("lservicio").style.display = 'none';
			document.getElementById("iarticulo").style.display = '';
			document.getElementById("iservicio").style.display = 'none';
		} 
		 
		if(document.form1.Item.value=="S"){
			document.getElementById("larticulo").style.display = 'none';
			document.getElementById("lservicio").style.display = '';
			document.getElementById("iarticulo").style.display = 'none';
			document.getElementById("iservicio").style.display = '';
		}                
	}      
</script>

<cfoutput>
<table width="85%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr> 
		<td align="right"><strong>Item:&nbsp;</strong></td>
		<td>
			<select name="Item" <cfif dmodo neq 'ALTA'>disabled</cfif> onChange="javascript:limpiarDetalle();cambiarDetalle();" tabindex="2">
				<option value="A" <cfif dmodo NEQ "ALTA" and trim(rsLinea.Aid) neq -1 >selected</cfif>>Art&iacute;culo</option>
				<option value="S" <cfif dmodo NEQ "ALTA" and trim(rsLinea.Cid) neq -1 >selected</cfif>>Concepto</option>
			</select>
		</td>

		<td align="right">
			<div id="larticulo" style="display:; "><strong>Art&iacute;culo:&nbsp;</strong></div>
			<div style="display:none;" id="lservicio"><strong>Servicio:&nbsp;</strong></div>
		</td>
		<td nowrap>
			<div id="iarticulo" style="display:;">
				<cfif dmodo eq 'ALTA'>
					<cf_sifarticulos>
				<cfelse>
					<cf_sifarticulos query="#rsArticulos#">
				</cfif>
			</div>
			<div id="iservicio" style="display:none;">

				<cfif dmodo eq 'ALTA'>
					<cf_sifconceptos tipo="G" >
				<cfelse>
					<cf_sifconceptos tipo="G" query="#rsConceptos#" >
				</cfif>
			</div>
		</td>

		<td align="right"><strong>Precio Unitario:&nbsp;</strong></td>
		<td>
			<cfparam name="rsLinea.DCpreciou" default="0">
			<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
			#LvarOBJ_PrecioU.inputNumber("DCpreciou", rsLinea.DCpreciou, "2", false, "", "", "", "")#
		</td>

		<td nowrap align="right"><strong>Garant&iacute;a:&nbsp;</strong></td>
		<td>
			<input name="DCgarantia" type="text" tabindex="2" style="text-align:right" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:document.form1.DCgarantia.select();" onChange="javascript:fm(this,0);" value="<cfif dmodo NEQ "ALTA">#rsLinea.DCgarantia#<cfelse>0</cfif>" size="5" maxlength="4"><strong>d&iacute;as</strong></td>

	</tr>

	<cfset tsD = "">
	<cfif dmodo NEQ "ALTA">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD"></cfinvoke>
		<input name="timestampD" type="hidden" value="#tsD#">	   
	</cfif>
</table>

<input name="DClinea" type="hidden" value="<cfif dmodo NEQ "ALTA">#rsLinea.DClinea#</cfif>">
</cfoutput>

<cfif dmodo neq 'ALTA'>
	<script type="text/javascript" language="javascript1.2">
		cambiarDetalle();
	</script>
</cfif>