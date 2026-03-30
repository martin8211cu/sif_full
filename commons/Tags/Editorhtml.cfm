<cfparam name="Attributes.name" 		default="MyTextArea" type="string" >
<cfparam name="Attributes.toolbarset" 	default="SIF" 		 type="string" >
<cfparam name="Attributes.value" 		default="" 			 type="string" >
<cfparam name="Attributes.indice" 		default="" 			 type="string" >
<cfparam name="Attributes.width"  		default="100%" 		 type="string">
<cfparam name="Attributes.height" 		default="200" 		 type="string">
<cfparam name="Attributes.Type" 		default="Custom" 	 type="string">
<cfparam name="Attributes.readonly" 	default="false" 	 type="boolean"><!---- en modo solo lectura se bloquea y no se muestran los controles--->
<cfparam name="Attributes.onLoad" 		default="" 	 		 type="string"><!---- funcion que se ejecutará al cargar el elemento--->

<cfset Attributes.value = replace(replace(Attributes.value, chr(13), ' ','all'),chr(10),'','all') >
<cfif not isdefined("Request.editorjs") >
	<cfparam name="Request.editorjs" default="true">
	<script type="text/javascript" src="/cfmx/rh/js/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/cfmx/rh/js/ckeditor/config.js"></script>
</cfif>


<textarea <cfif Attributes.readonly>readonly </cfif> name="<cfoutput>#Attributes.name##Attributes.indice#</cfoutput>" id="<cfoutput>#Attributes.name##Attributes.indice#</cfoutput>"><cfoutput>#Attributes.value#</cfoutput></textarea>

<cfif Attributes.readonly>
	<cfset attributes.Type='none'>
</cfif>

<script type="text/javascript">

	CKEDITOR.replace( '<cfoutput>#Attributes.name##Attributes.indice#</cfoutput>',{toolbar :
	<cfif Attributes.Type EQ "full">
		[
			[ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ],
			[ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ],
			[ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ]
			[ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ],
			[ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ],
			[ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ],
			[ 'Link','Unlink','Anchor' ],
			[ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ],
			[ 'Styles','Format','Font','FontSize' ],
			[ 'TextColor','BGColor' ],
			[ 'Maximize', 'ShowBlocks','-','About' ] 
		]
	<cfelseif Attributes.Type EQ "Custom">
		[
			['Styles', 'Format', 'Font', 'FontSize', 'Table', 'TextColor', 'BGColor', 'PageBreak'],
			['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', '-', 'About'],
			'/', ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Print', 'SpellChecker', 'Scayt'], 
			['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
			['Image','Table','HorizontalRule','SpecialChar','PageBreak','Iframe']
        ]
	<cfelseif Attributes.Type EQ "mini">
		[
			['Styles', 'Format', 'Font', 'FontSize', 'Table', 'TextColor', 'BGColor', 'PageBreak'],
			['Bold', 'Italic', '-', 'NumberedList', 'BulletedList'],
			['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
			['Image','Table']
        ]
	<cfelseif Attributes.Type EQ "none">
		[
			
        ]
	<cfelse>
		[
			[ 'Source', '-', 'Bold', 'Italic' ]
		]
	</cfif>
} );

<cfif Attributes.readonly>
	CKEDITOR.on('instanceReady', function (ev) {
	    ev.editor.setReadOnly(true);
	    <cfif len(trim(Attributes.onLoad))>
	    	<cfoutput>#Attributes.onLoad#</cfoutput>
	    </cfif>
	});	
</cfif>
</script>

