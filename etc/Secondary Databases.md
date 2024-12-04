# Secondary Databases
|Index|Database|Stim. Type|Stim. Dur.|Stim. N|Feature N.|Ppt. N|Ppt. Expertise|Ppt. Origin|Ppt. Sampling|Ppt. Task|Feature Source|Feature Categories|Citation|Comments|In studies
|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
1|[**EMOPIA**](https://annahung31.github.io/EMOPIA/)|Piano Solo (pop music)|30 to 40|387|24 (average of 20 MFCC + note length, velocity, beat note density, key)|4 total, 1 per song (annotators, not ppts)|not specified|not specified|presumably researchers|classify|MIDI Toolbox|NA|[Hung et al. (2021)](https://annahung31.github.io/EMOPIA/)|Article includes features roughly corresponding to Rhythm, Harmony, Timbre, but don't seem to be included in dataset
2|[**AMG1608**](https://github.com/loichan-tw/AMG1608_release)|pop|30|1608 |72|643 MTurk, 22 Taiwan subjects|no restrictions|MTurk|crowdsource|rate|MIRToolbox, YAAFE|[Timbre](https://github.com/loichan-tw/AMG1608_release/blob/main/feature_index.txt)|[Chen et al. (2015)](http://amg1608.blogspot.com/2015/02/the-amg1608-dataset-for-music-emotion.html)
3|[**NTUMIR**](https://web.archive.org/web/20170510081611/mac.citi.sinica.edu.tw/~yang/MER/NTUMIR-60)|Famous pop songs|25|60|46|99 (40 annotations per clip)|no restrictions|campus|convenience|rate|MIRToolbox, Sound Description Toolbox, MA Toolbox|Harmony, dynamic, melody, timbre, rhythm|Yang et al. (2011)* 
4|[**DEAM****](https://cvml.unige.ch/databases/DEAM/)|pop|58 full-length and 1744 45-second excerpts|1802|260|Total $n$ not specified. Minimum annotations per piece: 2013-14: 10; 2015: 5 MTurk workers|no restrictions|2013-14: MTurk; 2015: MTurk and Lab workers|crowdsourcing, convenience|rate|OpenSMILE|Melodic, Timbre, Voice, Dynamic, Harmony|[Aljanaki et al. (2017)](https://cvml.unige.ch/databases/DEAM/)
5|[**MediaEval2013/emoMusic/1000 songs**](https://cvml.unige.ch/databases/emoMusic/)|western pop of various genres|45|744|6669|min. 10 per clip [(100 qualified workers in final HIT)](https://ibug.doc.ic.ac.uk/media/uploads/documents/cmm13-soleymani.pdf)|Nonexperts (Mturk) + experts|MTurk|Crowdsourcing, presumed convenience for experts|rate|OpenSMILE|Melodic, Timbre, Voice, Dynamic, Harmony|[Soleymani et al. (2013)](https://cvml.unige.ch/databases/emoMusic/)
6|[**Soundtracks**](https://osf.io/p6vkg/wiki/home/)|obscure film soundtracks|5|110|none?|116 university students|nonmusicians|campus|convenience|rate, classify|NA|NA|[Eerola & Vuoskoski (2011)](https://osf.io/p6vkg/wiki/home/)
7|[**PSIC3839**](https://github.com/xl2218066/PSIC3839)|Chinese popular|full? 180 s excerpts extracted for analyses|3839|ns. About 10 feature categories. Unclear dimensionaltiy|87|no restrictions|campus|convenience|rate|Librosa|Melodic, Timbre, Harmony, Rhythm|[Liang et al. (2022)](https://github.com/xl2218066/PSIC3839)
8|[**CH818**](ccmir.cite.hku.hk/data/)|Chinese pop|30|818|15|3|experts|China|convenience|rate|MIRToolbox, PsySound, ChromaToolbox,Tempogram Toolbox|Dynamic, Melodic, Rhythm, Timbre, Harmony|Hu & Yang (2017)|15 rows of features appearing in the repo as 15 separate spreadsheets, though may also be 22 based on how they are listed in Table 4 of the paper..
9|[**Zhang et al. (2015)**](LINK)|Chinese pop|30|171|84 dimensions|10|Nonexperts|not specified|not specified|classify|MAToolbox, MIRToolbox, Coversongs|Dynamics, Timbre, Rhythm|Zhang et al. 2015
10|[**PMEmo**](http://huisblog.cn/PMEmo/)|choruses of top pop songs|variable|794|6373 static; 260 acoustic low-level features|457|366 Chinese university students (44 music majors); 47 English speakers|campus|convenience|rate|ComParE 2013 baseline feature set|Dynamic, Timbre, Melodic|[Zhang et al. (2018)](https://github.com/HuiZhangDB/PMEmo?tab=readme-ov-file)|
11|[**NJU-V1**](https://cs.nju.edu.cn/sufeng/data/musicmood.htm)|Music clips (limited detail)|variable|777|Lyric (BoW; 50 dims before filtering), MFCC, spectral contrast, chromagram|NA (lastfm tags)|NA|LastFM|crowdsource (webscraping)|NA|NA|Lyric, Timbre, Harmony|[Xue et al. (2015)](https://cs.nju.edu.cn/sufeng/data/musicmood.htm)
12|[**ISMIR-2012**](http://yadingsong.blogspot.com/2015/03/popular-music-emotion-dataset-ismir2012.html)|popular|30 or 60|2904|54 (means + sds)|NA (lastfm tags)|NA|LastFM|crowdsource (webscraping)|NA|MIRToolbox|Dynamics, Rhythm, Timbre (they call this Spectral), Harmony|[Song et al. 2012](http://yadingsong.blogspot.com/2015/03/popular-music-emotion-dataset-ismir2012.html)**|
13|[**Spotify API**](https://developer.spotify.com/documentation/web-api)|Various|Variable|>35,000,000 (5192 used in @alvarez)|12|NA|NA|NA|NA|NA|EchoNest|Dynamic,Rhythm,High-level, Harmony, *duration*|
14|[**Acoustic Brainz**](https://acousticbrainz.org/)|Various|Variable|7,564,215 unique (60,000 used in @alvarez)|From Essentia (discuss)|NA (lastfm tags)|NA|LastFM|crowdsource (webscraping)|NA|Essentia|Dynamic, Melodic, Rhythm, Timbre, Harmony|Porter et al. (2015)
15|[**MIREX2009**](https://www.music-ir.org/mirex/wiki/2009:Music_Structure_Segmentation_Results)|Popular|Full?|297|3 (onset, offset, label)|NA|NA|NA|NA|NA|Paulus & Klapuri (2009)|Form|Paulus & Klapuri (2009)
16|[**Million Songs Dataset**](http://millionsongdataset.com/pages/getting-dataset/)|Pop|Full [or 30s]|1,000,000 (also subset of 10,000)|55 per song|none|NA|NA|NA|NA|EchoNest|Dynamic,Rhythm,High-level, Harmony|Bertin-Mahieux et al. (2011)|NA|NA|NA
17|[**Free Music Archive**](https://freemusicarchive.org/home)|Various|Variable|>100,000|NA|NA|NA|NA|NA|NA|NA|NA|NA
18|[**MIREX 2015/MIREX Grand Challenge on User Experience (Jamendo)/GC15UX**](https://www.music-ir.org/mirex/wiki/2015:Main_Page)|Various|Variable|10,000|24 metadata features listed|NA|NA|NA|NA|NA|Metadata|High-level|Bogdanov et al. (2019)
19|**Chinese Classical Music Dataset**|Chinese classical|~30s|500|557|20|audio technology|Chinese bg|Volunteer|Rate|Essentia, MIRToolbox|Timbre, Dynamic, Rhythm, High-level|Wang et al. (2022)

\* Dataset not available online

\** Only lyrics & timestamps included in public dataset 

# References

> Aljanaki, A., Yang, Y. H., & Soleymani, M. (2017). Developing a benchmark for emotional analysis of music. PloS one, 12(3), e0173392.

> Chen, Y. A., Yang, Y. H., Wang, J. C., & Chen, H. (2015, April). The AMG1608 dataset for music emotion recognition. In 2015 IEEE international conference on acoustics, speech and signal processing (ICASSP) (pp. 693-697). IEEE.

> Eerola, T. & Vuoskoski, J. K. (2011). A comparison of the discrete and dimensional models of emotion in music. Psychology of Music, 39(1), 18-49. https://doi.org/10.1177/0305735610362821

> Hu, X., & Yang, Y. H. (2017). The mood of Chinese Pop music: Representation and recognition. Journal of the Association for Information Science and Technology, 68(8), 1899-1910.

> Hung, H. T., Ching, J., Doh, S., Kim, N., Nam, J., & Yang, Y. H. (2021). EMOPIA: A multi-modal pop piano dataset for emotion recognition and emotion-based music generation. arXiv preprint arXiv:2108.01374.

> Soleymani, M., Caro, M. N., Schmidt, E. M., Sha, C. Y., & Yang, Y. H. (2013, October). 1000 songs for emotional analysis of music. In Proceedings of the 2nd ACM international workshop on Crowdsourcing for multimedia (pp. 1-6).

> Xu, L., Yun, Z., Sun, Z., Wen, X., Qin, X., & Qian, X. (2022). PSIC3839: Predicting the Overall Emotion and Depth of Entire Songs. In Design Studies and Intelligence Engineering (pp. 1-9). IOS Press.

> Xue, H., Xue, L., & Su, F. (2015). Multimodal music mood classification by fusion of audio and lyrics. In MultiMedia Modeling: 21st International Conference, MMM 2015, Sydney, NSW, Australia, January 5-7, 2015, Proceedings, Part II 21 (pp. 26-37). Springer International Publishing.

> Zhang, J. L., Huang, X. L., Yang, L. F., Xu, Y., & Sun, S. T. (2017). Feature selection and feature learning in arousal dimension of music emotion by using shrinkage methods. Multimedia systems, 23, 251-264.

> Zhang, K., Zhang, H., Li, S., Yang, C., & Sun, L. (2018, June). The PMEmo dataset for music emotion recognition. In Proceedings of the 2018 acm on international conference on multimedia retrieval (pp. 135-142).

> Song, Y., Dixon, S., & Pearce, M. T. (2012, October). Evaluation of musical features for emotion classification. In ISMIR (pp. 523-528).

> Porter, A., Bogdanov, D., Kaye, R., Tsukanov, R., & Serra, X. (2015). Acousticbrainz: a community platform for gathering music information obtained from audio. In Müller M, Wiering F, editors. ISMIR 2015. 16th International Society for Music Information Retrieval Conference; 2015 Oct 26-30; Málaga, Spain. Canada: ISMIR; 2015. International Society for Music Information Retrieval (ISMIR).

> Bertin-Mahieux, T., Ellis, D. P., Whitman, B., & Lamere, P. (2011). The million song dataset.

> Bogdanov, D., Won, M., Tovstogan, P., Porter, A., & Serra, X. (2019). The mtg-jamendo dataset for automatic music tagging. ICML.

>  Wang, X., Wang, L., & Xie, L. (2022). Comparison and analysis of acoustic features of western and Chinese classical music emotion recognition based on VA model. Applied Sciences, 12(12), 5787.

> Paulus, J., & Klapuri, A. (2009). Labelling the structural parts of a music piece with Markov models. In Computer Music Modeling and Retrieval. Genesis of Meaning in Sound and Music: 5th International Symposium, CMMR 2008 Copenhagen, Denmark, May 19-23, 2008 Revised Papers 5 (pp. 166-176). Springer Berlin Heidelberg.

[comment]: # (|)