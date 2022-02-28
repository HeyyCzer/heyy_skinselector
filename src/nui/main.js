var blockSelect = false;

window.addEventListener("message", (event) => {
	if (event.data.action === "abrir") {
		$("#actionmenu").show();
		retrieveSkins();
	} else if (event.data.action === "fechar") {
		$("#actionmenu").hide();
	}
});

document.onkeyup = function (data) {
	if (data.which == 27) if ($("#actionmenu").is(":visible")) $.post(`http://${GetParentResourceName()}/close`, {});
};

$("#selectSkin-button").on("click", () => {
	blockSelect = true;

	const button = $("#selectSkin-button");
	button.prop("disabled", true);
	button.html(`<img src="imgs/loading.svg" style="height: 40px; width: 60px" alt="Carregando"/>`);

	var skins = [];
	$(".skin-active").each(function () {
		skins.push($(this).data("skinmodel"));
	});

	if (skins.length < 1) {
		$.post(`http://${GetParentResourceName()}/notify`, JSON.stringify({ type: "negado", message: "Você precisa escolher ao menos uma Skin!" }));
		$("#selectSkin-button").html("Pronto");
		$("#selectSkin-button").prop("disabled", false);
		return;
	}

	$.post(`http://${GetParentResourceName()}/selectSkin`, JSON.stringify({ skin: skins[0] }), (responseCode) => {
		if (responseCode == 200) {
			$.post(`http://${GetParentResourceName()}/close`);
			$("#skinList").html("");
		}

		$("#selectSkin-button").html("Pronto");
		$("#selectSkin-button").prop("disabled", false);

		blockSelect = false;
	});
});

$("#skinList").on("click", ".skin", function () {
	if (blockSelect) return;

	$(".skin-active").toggleClass("skin-active", false);
	$(this).toggleClass("skin-active", true);
});

function retrieveSkins() {
	$("#skinList").html("");
	$.post(`http://${GetParentResourceName()}/getAvailableSkins`, JSON.stringify({}), (data) => {
		for (var skin of data.skins) {
			$("#skinList").append(`
				<div class="skin card mb-3" style="width: 540px; height: 100px;" data-skinmodel="${skin.model}">
					<div class="row g-0 h-100">
						<div class="col-md-4">
							<img src="${skin.image}" class="h-100 w-100 rounded-start" onerror="if (this.src != 'imgs/default.png') this.src = 'imgs/default.png';" />
						</div>
						<div class="col-md-8">
							<div class="card-body">
								<h5 class="card-title fw-bolder">${skin.name}</h5>
								<p class="card-text fw-normal">Clique para selecionar</b></p>
							</div>
						</div>
					</div>
				</div>
			`);
		}
	});
}
