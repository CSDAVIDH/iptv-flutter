import 'package:flutter/material.dart';
import '../../../core/models/channel.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/favorites_service.dart';
import 'streaming_controller.dart';
import 'streaming_screen.dart';

class StreamingHomeScreen extends StatefulWidget {
  final String m3uUrl;
  const StreamingHomeScreen({super.key, required this.m3uUrl});

  @override
  State<StreamingHomeScreen> createState() => _StreamingHomeScreenState();
}

class _StreamingHomeScreenState extends State<StreamingHomeScreen> {
  late Future<List<Channel>> _channelsFuture;
  List<Channel> _allChannels = [];
  List<Channel> _filteredChannels = [];
  String _searchQuery = '';
  String _selectedGroup = 'Todos';
  List<String> _groups = ['Todos'];
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _channelsFuture = StreamingController().getChannels(widget.m3uUrl);
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    try {
      final channels = await StreamingController().getChannels(widget.m3uUrl);
      setState(() {
        _allChannels = channels;
        _filteredChannels = channels;
        _groups = ['Todos'];
        _groups.addAll(channels
            .where((c) => c.group != null && c.group!.isNotEmpty)
            .map((c) => c.group!)
            .toSet()
            .toList());
      });
    } catch (e) {
      // Handle error
    }
  }

  void _filterChannels() {
    setState(() {
      _filteredChannels = _allChannels.where((channel) {
        final matchesSearch = channel.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesGroup = _selectedGroup == 'Todos' || channel.group == _selectedGroup;
        return matchesSearch && matchesGroup;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Canales IPTV'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters
          _buildSearchAndFilters(),
          // Channels list/grid
          Expanded(
            child: FutureBuilder<List<Channel>>(
              future: _channelsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.tv_off,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron canales',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                if (_allChannels.isEmpty) {
                  _allChannels = snapshot.data!;
                  _filteredChannels = _allChannels;
                }
                
                return _isGridView ? _buildGridView() : _buildListView();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Buscar canales...',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _filterChannels();
              },
            ),
          ),
          const SizedBox(height: 12),
          // Groups filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _groups.length,
              itemBuilder: (context, index) {
                final group = _groups[index];
                final isSelected = group == _selectedGroup;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      group,
                      style: TextStyle(
                        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGroup = group;
                      });
                      _filterChannels();
                    },
                    backgroundColor: AppColors.cardBackground,
                    selectedColor: AppColors.secondary,
                    checkmarkColor: AppColors.textPrimary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredChannels.length,
      itemBuilder: (context, index) {
        final channel = _filteredChannels[index];
        return _buildChannelGridCard(channel);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredChannels.length,
      itemBuilder: (context, index) {
        final channel = _filteredChannels[index];
        return _buildChannelListCard(channel);
      },
    );
  }

  Widget _buildChannelGridCard(Channel channel) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamingScreen(url: channel.url),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.surface,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Channel logo/thumbnail
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: channel.logo != null && channel.logo!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              channel.logo!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.tv,
                                size: 32,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.tv,
                            size: 32,
                            color: AppColors.textSecondary,
                          ),
                  ),
                ),
                // Channel info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (channel.group != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            channel.group!,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: FutureBuilder<bool>(
                future: FavoritesService.isFavorite(channel),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;
                  return InkWell(
                    onTap: () async {
                      await FavoritesService.toggleFavorite(channel);
                      setState(() {}); // Refresh the UI
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite 
                                  ? '${channel.name} eliminado de favoritos'
                                  : '${channel.name} agregado a favoritos',
                            ),
                            backgroundColor: AppColors.surface,
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isFavorite 
                            ? AppColors.accent
                            : Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelListCard(Channel channel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surface,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: channel.logo != null && channel.logo!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    channel.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.tv,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : Icon(
                  Icons.tv,
                  color: AppColors.textSecondary,
                ),
        ),
        title: Text(
          channel.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          channel.group ?? 'Sin categoría',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder<bool>(
              future: FavoritesService.isFavorite(channel),
              builder: (context, snapshot) {
                final isFavorite = snapshot.data ?? false;
                return InkWell(
                  onTap: () async {
                    await FavoritesService.toggleFavorite(channel);
                    setState(() {}); // Refresh the UI
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite 
                                ? '${channel.name} eliminado de favoritos'
                                : '${channel.name} agregado a favoritos',
                          ),
                          backgroundColor: AppColors.surface,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? AppColors.accent : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
            Icon(
              Icons.play_arrow,
              color: AppColors.secondary,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamingScreen(url: channel.url),
            ),
          );
        },
      ),
    );
  }
}
