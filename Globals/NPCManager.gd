extends Node


var NPC_images_by_id={}



const territory_names = ["Fiblus","Cogram","Lors","Beiel","Blek","Sziam","Bembel","Pollotrix",
				"Zambus","Godder","Pelizee","Pisa","Kakau","Postolus","Golbos","Pingrus",
				"Maltos","Zobat","Ailhum","Awmdust","Buhk","Bunen","Cellardor","Caicriet",
				"Damnus","Dillin","Dale","Eor","Eol","Eers","Eest","Aard","Frist","Moin",
				"Fourwind","Dillah","Gein","Gorgorath","Golageth","Bonhunmin","Erebor",
				"Galgador","Eighnt","Hournlese","Iggles","Inglin","Imadist","Journ","Jassas",
				"Jabor","Klin","Kilzin","Kakamera","Loonis","Lor","Lapp","Malictan","Molos",
				"Mipttin","Mhils","Mill","Goddard","Nilis","Nourn","Namadis","Ourpin","Omi",
				"Otronsour","Oatsome","Oovf","Palis","Poridoun","Panthil","Perra","Queres",
				"Qarth","Quern","Rasputun","Rantan","Rous","Rountour","Simsillis","Sous",
				"Saurian","Gadarkus","Meeble"]
				
				



const names = {
	"Human":["Micheal","Robert","Sam","Alex","Alice","Max","Aubrey","Albus","Adrian","Blake",
	"Jess","Avery","Harper","Carey","James","Jimmy","Cadmus","Iphicles","Perses","Rama",
	"Jon","Stephen","Robin","Godot","Goddard","Tupus","Lief","Aesop","Adonis","Dorian",
	"Baul","Bob","Bobus","Bobeus","Carol","Dran","Daniel","David","Elinor","Elizabeth",
	"Paul","Peter","Marcus","Winifred","P.","Pompeius","Klateus"],
	
	"Fey":["Santamas","Leaf","Greenface","Puck","Titania","Dabebus","Mars","Leafeon",
	"Lors","Maliach","Malechai","Pinkus","Fifis","Dalius"],

	"Centaur":["Blus","Tremblus","Arcophon","Trimnulus","Shooter","Darter","Zalmoxis","Chiron",
	"Nessus","Pholos","Ixion","Polkan","Centaurus","Chromis","Abas","Firenze","Bane","Ronan",
	"Throm","Thrombus","Strummer","Wizere","Breius","Demophon","Gobreaker","Swin","Parouk",
	"Whinny"],

	"Dark Elf":["Abraus","Cadabrus","Cadeusus","Demoseus","Bejexin","Bahseun","Avlenis","Alvar",
	"Adin","Averius","Berrick","Belmess","Bibelos","Calgent","Maeglor","Faenor","Anor","Agnor",
	"Celegorn","Carithir","Finwe","Cuivienen","Dvegar","Eol","Maeglin","Dipus"],

	"Djinn":["Alibaba","Gini","Geneie","Simini","Topaba","Ginsinc","Alimorabi","Jinius","Aljinn",
	],
	
	"Gnome":["Billi","Gimbus","Po","Lala","Tinkiwinkie","Bongo","Boingino","Bingbong","Dumpy",
	"Peepee","Uni","Buttercup","Bop","Bippi","Bip","Mango","Molly","Jai","Pino","Homina",
	"Gaga","Gagot","Godot","Meep","Dom","Doc","Sleepy","Happy","Horp","Hoopi","Dumbo","Sweepy",
	"Fizzlebizzle","Dewbum","Dewdrop","Gungadin","Googoo","Meeblus","Doodoo","Pe",
	"Wazzle","Hopper"],
	
	"Talking Bear":["Aaarugh","Harourgh","Ouroaugh","Orough","Aaraugh","Aeragh","Chourch",
	"Krough","Krruournn","Aughruh","Ourourr","Bjornik","Grrowough","Grough","Roaaour","Roaur",
	"Rrourgh","Ursurag","Ursus","Uurctur","Arctor","Aaarac","Arakaa","Grrerr","Kyasshk","Araough",
	"Rrourgh","Aarourgh","Roaghrough","Agaahrouh","Grrgaugh","Grrosough"]
}

const surnames = {
	"Human":["Bormus","Osmian","Redface","Beorson","Landerflater","Thawborn","Hibus","Dotter",
	"Borrius","Zambia","Puros","Cadmilos","Hornless","Bridgefinder","Ford","Ferry","Babaius",
	"Pondoce","Cadmus","Eel","Elephantis","Bagbin","Grumpee","Hunn","Boin","Nailbitter","Momps",
	"Morbius","Stuss","Homan","Haoman","Levi","Bagger","Priece","Pepperknick","Himmen","Swift",
	"Giantslayer","Bigfoot","Tinyfeet","Venture","Ventura","Bamford","Piecie","Pastopus",
	"Fox","Frist","Silver","Goldie","Configaro","Fikregus","Scraff","Cerealster","Starr",
	"Biggs","Sinston","Frankie","Wonwod","Keplaff","Nosay","Dadeto","Awoneiti","Sharpe",
	],

	"Centaur":["Longhoof","Sweetongue","Highbrow","Stargazer","Mightistride","Rosewater",
	"Gladeson","Groveson","Riverrunner","Logjumper","Winifred","Sonjon","Rivers","Sugarfield",
	"Sugarmen","Diamond","Rockbreaker","Stomper","Sunspear","Cossack","Sheepist",
	"Ramfist","Longhand","Horneblower","Horne","Splott","Maneater","Manston","Mann",
	"Viola","Diccus"],
	
	"Dark Elf":["Svergar","Dvegar","Darkleaf","Deeplore","Wideye","Coldheart","Brighteye",
	"Swift","Lightstep","Barkskin","Treelover","Shrublover","Leaflover","Leaper","Fireheart",
	"Coldstone","Stoneheart","Freewills","Dvegarson"],
	
	"Gnome":["Baggins","Bagender","Fluttlebottom","Butterump","Flutterbum","Gumdrop","Hornblower",
	"Hornsitter","Pixidust","Buttercup","Flowerhat","Squeakshoe","Bubblebutt","Flatass","Blubberer",
	"Twistie","Poleslider","Pillowbottom","Bumbum","Fartipants","Pointop","Jingleshoe","Ditchdigger",
	"Flower","Bugsby","Chocotot","Tottler","Applebottom","Cumguzzler","Chortletoot",
	"Funbucket","Fuzzbucket","Smellyhat","Tootsalot","Sneezefart","Sharter"]
	
}
