<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="311" returnvariable="popServer"/>
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="312" returnvariable="popUsername"/>
<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="313" returnvariable="popPassword"/>

<cfif IsDefined('form.messagenumber')>

	<cfpop server="#popServer#" username="#popUsername#" password="#popPassword#" name="este"
		action="delete" messagenumber="# form.messagenumber #"/>
<cfelse>
	<cfpop server="#popServer#" username="#popUsername#" password="#popPassword#" name="este"
		action="delete" messagenumber="# form.uid #"/>
</cfif>
<cflocation url="index.cfm?tab=spam&filtro_From=#URLEncodedFormat( form.filtro_From ) #&filtro_To=#URLEncodedFormat( form.filtro_To ) #&filtro_Subject=#URLEncodedFormat( form.filtro_Subject ) #&filtro_Date=#URLEncodedFormat( form.filtro_Date ) #&PageNum_lista=#URLEncodedFormat( form.PageNum_lista ) #">