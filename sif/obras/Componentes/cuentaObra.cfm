<cfparam name="Attributes.OBOid">
<cfparam name="Attributes.name">
<cfparam name="Attributes.value" default="">
<cfparam name="Attributes.onEnter" default="">

<cfoutput>

<cfquery datasource="#session.dsn#" name="rsSQL">
	select 
		   tp.OBTPid, tp.OBTPtipoCtaLiquidacion, tp.OBTPnivelProyecto, tp.OBTPnivelObra, tp.OBTPnivelObjeto
		 , p.OBPid, p.OBPcodigo, p.OBPdescripcion, p.PCEcatidObr, p.CFformatoPry
		 , o.OBOcodigo, o.CFformatoObr
		 , m.PCEMformato
		 , tp.OBTPnivelProyecto, tp.OBTPnivelObra
		 , ec.PCEcodigo, ec.PCEdescripcion, ec.PCElongitud, ec.PCEempresa, ec.PCEoficina
	  from OBobra o
		inner join OBproyecto p
			inner join OBtipoProyecto tp
				inner join PCEMascaras m
				   on m.PCEMid	= tp.PCEMid
				on tp.OBTPid = p.OBTPid
			inner join PCECatalogo ec
			   on ec.PCEcatid = p.PCEcatidObr
			on p.OBPid = o.OBPid
	 where o.OBOid = #Attributes.OBOid#
</cfquery>

<cfif attributes.value EQ "">
	<cfset LvarObra_Formato = rsSQL.CFformatoObr & mid(rsSQL.PCEMformato,len(rsSQL.CFformatoObr)+1,100)>
<cfelse>
	<cfset LvarObra_Formato = rsSQL.CFformatoObr & mid(attributes.value,len(rsSQL.CFformatoObr)+1,100)>
</cfif>
<cfset LvarObra_Formato = replace(LvarObra_Formato,"X"," ","ALL")>
<cfset LvarObra_Niveles = listToArray(LvarObra_Formato,"-")>
<cfset LvarObra_Niveles[rsSQL.OBTPnivelProyecto+1]	= trim(rsSQL.OBPcodigo)>
<cfset LvarObra_Niveles[rsSQL.OBTPnivelObra+1] 	 	= trim(rsSQL.OBOcodigo)>

<input type="hidden" name="#Attributes.name#" id="#Attributes.name#"
	<cfif Attributes.value NEQ "">
		value="#LvarObra_Formato#"
	</cfif>
/>
<cfloop index="LvarIdx" from="1" to="#arrayLen(LvarObra_Niveles)#"><cfif LvarIdx GT 1>-</cfif><input 
		type="text" name="CFformato_#LvarIdx-1#" id="CFformato_#LvarIdx-1#" 
		value="#HTMLEditFormat(LvarObra_Niveles[LvarIdx])#" 
	<cfif len(LvarObra_Niveles[LvarIdx]) gt 5>
		size="#len(LvarObra_Niveles[LvarIdx])+2#"
	<cfelse>
		size="#len(LvarObra_Niveles[LvarIdx])#"
	</cfif>
		maxlength="#len(LvarObra_Niveles[LvarIdx])#"
	<cfset LvarNiv = LvarIdx - 1>
	<cfif LvarNiv LTE rsSQL.OBTPnivelObra AND trim(LvarObra_Niveles[LvarIdx]) NEQ "">
		readonly="yes" style="border:solid 1px ##CCCCCC" tabindex="-1"
	<cfelse>
		onfocus="if (this.readOnly) return; this.select()"
		onblur="if (this.readOnly) return; this.value = fnConCeros(this.value,#len(LvarObra_Niveles[LvarIdx])#); fnCFformatoCompleto();"
	</cfif>
	<cfif LvarIdx EQ arrayLen(LvarObra_Niveles)>
		onkeydown="if (((event.which) ? event.which : window.event.keyCode) == 13) {this.blur(); #Attributes.OnEnter#} "
	</cfif>
></cfloop>

<script>
	function sbGOGid_change(obj)
	{
		if (obj.selectedIndex == 0)
		{
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").value		= "";
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").readOnly	= false;
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").tabIndex	= "0";
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").style.border	= window.Event ? "" : "inset 2px";
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").backGround		= "";
			document.getElementById("btnAltaCta").style.display = "";
			document.getElementById("btnAltaMasivo").style.display = "none";
		}
		else
		{
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").value			= "[OG]";
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").readOnly		= true;
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").tabIndex		= "-1";
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").style.border	= "solid 1px ##CCCCCC";
			document.getElementById("CFformato_#rsSQL.OBTPnivelObjeto#").backGround		= "inherit";
			document.getElementById("btnAltaCta").style.display = "none";
			document.getElementById("btnAltaMasivo").style.display = "";
		}
	}

	function fnCFformatoCompleto(verificar)
	{
		var LvarCFformato = document.getElementById("CFformato_0").value;
<cfloop index="LvarIdx" from="1" to="#arrayLen(LvarObra_Niveles)-1#">
		if (verificar && document.getElementById("CFformato_#LvarIdx#").value.replace(/\s*/,"") == "")
		{
			alert("Debe completar todos los niveles de la cuenta");
			return "";
		}
		else
		{
		<cfif LvarIdx EQ rsSQL.OBTPnivelObjeto>
			if (document.getElementById("CFformato_#LvarIdx#").readOnly)
				LvarCFformato += "-[OG]";
			else
				LvarCFformato += "-" + fnConCeros(document.getElementById("CFformato_#LvarIdx#").value,#len(LvarObra_Niveles[LvarIdx+1])#);
		<cfelse>
			LvarCFformato += "-" + fnConCeros(document.getElementById("CFformato_#LvarIdx#").value,#len(LvarObra_Niveles[LvarIdx+1])#);
		</cfif>
		}
</cfloop>
		document.getElementById("#Attributes.name#").value = LvarCFformato;

		return LvarCFformato;
	}

	function fnConCeros(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		if (LprmHilera == "")
			return "";
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"0";
		return fnRight(s + LprmHilera, LprmLong);
	}		 
	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}		 
	function fnLTrim(LvarHilera)
	{
		return LvarHilera.replace(/^\s+/,'');
	}
	function fnRTrim(LvarHilera)
	{
		return LvarHilera.replace(/\s+$/,'');
	}
	function fnTrim(LvarHilera)
	{
	   return fnRTrim(fnLTrim(LvarHilera));
	}

</script>
</cfoutput>